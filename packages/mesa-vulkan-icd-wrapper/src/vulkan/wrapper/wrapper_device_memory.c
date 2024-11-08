#define native_handle_t __native_handle_t
#define buffer_handle_t __buffer_handle_t
#include "wrapper_private.h"
#include "wrapper_entrypoints.h"
#include "vk_common_entrypoints.h"
#undef native_handle_t
#undef buffer_handle_t
#include "util/hash_table.h"
#include "util/os_file.h"
#include "vk_util.h"

#include <android/hardware_buffer.h>
#include <vndk/hardware_buffer.h>
#include <sys/mman.h>
#include <sys/ioctl.h>
#include <linux/dma-heap.h>

static int
safe_ioctl(int fd, unsigned long request, void *arg)
{
   int ret;

   do {
      ret = ioctl(fd, request, arg);
   } while (ret == -1 && (errno == EINTR || errno == EAGAIN));

   return ret;
}

static int
dma_heap_alloc(int heap_fd, size_t size) {
   struct dma_heap_allocation_data alloc_data = {
      .len = size,
      .fd_flags = O_RDWR | O_CLOEXEC,
   };
   if (safe_ioctl(heap_fd, DMA_HEAP_IOCTL_ALLOC, &alloc_data) < 0)
      return -1;

   return alloc_data.fd;
}

static int
ion_heap_alloc(int heap_fd, size_t size) {
   struct ion_allocation_data {
      __u64 len;
      __u32 heap_id_mask;
      __u32 flags;
      __u32 fd;
      __u32 unused;
   } alloc_data = {
      .len = size,
      /* ION_HEAP_SYSTEM | ION_SYSTEM_HEAP_ID */
      .heap_id_mask = (1U << 0) | (1U << 25),
      .flags = 0, /* uncached */
   };

   if (safe_ioctl(heap_fd, _IOWR('I', 0, struct ion_allocation_data),
                  &alloc_data) < 0)
      return -1;

   return alloc_data.fd;
}

static int
wrapper_dmabuf_alloc(struct wrapper_device *device, size_t size)
{
   int fd;

   fd = dma_heap_alloc(device->physical->dma_heap_fd, size);

   if (fd < 0)
      fd = ion_heap_alloc(device->physical->dma_heap_fd, size);

   return fd;
}

static VkResult
wrapper_get_import_dmabuf_info(struct wrapper_device *device,
                               VkMemoryAllocateInfo *alloc_info,
                               VkImportMemoryFdInfoKHR *fd_info,
                               const void *pnext)
{
   int import_dmabuf_fd;
   int memory_type_index;
   VkResult result;

   import_dmabuf_fd = wrapper_dmabuf_alloc(device,
      alloc_info->allocationSize);
   if (import_dmabuf_fd < 0)
      return VK_ERROR_INVALID_EXTERNAL_HANDLE;

   VkMemoryFdPropertiesKHR memory_fd_props = {
      .sType = VK_STRUCTURE_TYPE_MEMORY_FD_PROPERTIES_KHR,
      .pNext = NULL,
   };
   result = device->dispatch_table.GetMemoryFdPropertiesKHR(
      device->dispatch_handle, VK_EXTERNAL_MEMORY_HANDLE_TYPE_DMA_BUF_BIT_EXT,
      import_dmabuf_fd, &memory_fd_props);
   if (result != VK_SUCCESS) {
      close(import_dmabuf_fd);
      return VK_ERROR_INVALID_EXTERNAL_HANDLE;
   }

   memory_type_index = wrapper_select_memory_type(
      device->physical->memory_properties,
      device->physical->memory_properties.memoryTypes[
      alloc_info->memoryTypeIndex].propertyFlags |
      memory_fd_props.memoryTypeBits);
   if (memory_type_index >= UINT32_MAX) {
      close(import_dmabuf_fd);
      return VK_ERROR_INVALID_EXTERNAL_HANDLE;
   }

   *fd_info = (VkImportMemoryFdInfoKHR) {
      .sType = VK_STRUCTURE_TYPE_IMPORT_MEMORY_FD_INFO_KHR,
      .pNext = pnext,
      .fd = import_dmabuf_fd,
      .handleType =
         VK_EXTERNAL_MEMORY_HANDLE_TYPE_DMA_BUF_BIT_EXT,
   };

   alloc_info->pNext = fd_info;
   alloc_info->memoryTypeIndex = memory_type_index;
   return VK_SUCCESS;
}

VKAPI_ATTR VkResult VKAPI_CALL
wrapper_AllocateMemory(VkDevice _device,
                       const VkMemoryAllocateInfo* pAllocateInfo,
                       const VkAllocationCallbacks* pAllocator,
                       VkDeviceMemory* pMemory)
{
   VK_FROM_HANDLE(wrapper_device, device, _device);
   const VkImportAndroidHardwareBufferInfoANDROID *import_ahb_info;
   const VkImportMemoryFdInfoKHR *import_fd_info;
   const VkExportMemoryAllocateInfo *export_info;
   VkImportMemoryFdInfoKHR local_import_info = { .fd = -1 };
   VkExportMemoryAllocateInfo local_export_info;
   VkMemoryAllocateInfo wrapper_allocate_info;
   struct wrapper_device_memory *memory;
   VkMemoryPropertyFlags memory_type;
   bool can_get_ahardware_buffer;
   bool can_get_dmabuf_fd;
   VkResult result;

   memory_type = device->physical->memory_properties.memoryTypes
      [pAllocateInfo->memoryTypeIndex].propertyFlags;

   if (!device->vk.enabled_extensions.EXT_map_memory_placed ||
       !device->vk.enabled_features.memoryMapPlaced ||
       !(memory_type & VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT))
   {
      return device->dispatch_table.AllocateMemory(
         device->dispatch_handle, pAllocateInfo, pAllocator,
         pMemory);
   }

   memory = vk_zalloc2(&device->vk.alloc, pAllocator, sizeof(*memory),
                       8, VK_SYSTEM_ALLOCATION_SCOPE_OBJECT);
   if (!memory)
      return vk_error(device, VK_ERROR_OUT_OF_HOST_MEMORY);

   memory->alloc_size = pAllocateInfo->allocationSize;
   memory->dmabuf_fd = -1;
   wrapper_allocate_info = *pAllocateInfo;
   
   import_ahb_info = vk_find_struct_const(pAllocateInfo,
      IMPORT_ANDROID_HARDWARE_BUFFER_INFO_ANDROID);
   import_fd_info = vk_find_struct_const(pAllocateInfo,
      IMPORT_MEMORY_FD_INFO_KHR);
   export_info = vk_find_struct_const(pAllocateInfo,
      EXPORT_MEMORY_ALLOCATE_INFO);

   if (import_ahb_info) {
      memory->ahardware_buffer = import_ahb_info->buffer;
      AHardwareBuffer_acquire(memory->ahardware_buffer);
   } else if (import_fd_info) {
      memory->dmabuf_fd = os_dupfd_cloexec(import_fd_info->fd);
   } else if (!export_info) {
      export_info = &local_export_info;
   }

   if (export_info == &local_export_info) {
      local_export_info = (VkExportMemoryAllocateInfo) {
         .sType = VK_STRUCTURE_TYPE_EXPORT_MEMORY_ALLOCATE_INFO,
         .pNext = pAllocateInfo->pNext,
         .handleTypes =
            VK_EXTERNAL_MEMORY_HANDLE_TYPE_DMA_BUF_BIT_EXT,
      };
      wrapper_allocate_info.pNext = &local_export_info;
   }

   result = device->dispatch_table.AllocateMemory(
      device->dispatch_handle, &wrapper_allocate_info,
      pAllocator, pMemory);

   if (export_info == &local_export_info && result != VK_SUCCESS)
   {
      result = wrapper_get_import_dmabuf_info(device,
         &wrapper_allocate_info, &local_import_info,
         pAllocateInfo->pNext);

      if (result == VK_SUCCESS) {
         memory->dmabuf_fd = os_dupfd_cloexec(
            local_import_info.fd);

         result = device->dispatch_table.AllocateMemory(
            device->dispatch_handle, &wrapper_allocate_info,
            pAllocator, pMemory);

         if (result != VK_SUCCESS) {
            close(local_import_info.fd);
            local_import_info.fd = -1;
            close(memory->dmabuf_fd);
            memory->dmabuf_fd = -1;
         } else {
            export_info = NULL;
         }
      }
   }

   if (export_info == &local_export_info && result != VK_SUCCESS)
   {
      local_export_info.handleTypes =
         VK_EXTERNAL_MEMORY_HANDLE_TYPE_ANDROID_HARDWARE_BUFFER_BIT_ANDROID;

      wrapper_allocate_info.pNext = &local_export_info;

      result = device->dispatch_table.AllocateMemory(
         device->dispatch_handle, &wrapper_allocate_info,
         pAllocator, pMemory);
   }

   if (result != VK_SUCCESS) {
      if (memory->ahardware_buffer)
         AHardwareBuffer_release(memory->ahardware_buffer);
      if (memory->dmabuf_fd != -1)
         close(memory->dmabuf_fd);
      vk_free2(&device->vk.alloc, pAllocator, memory);
      return vk_error(device, result);
   }

   _mesa_hash_table_insert(device->memorys, (void *)(*pMemory), memory);

   can_get_dmabuf_fd = (export_info && export_info->handleTypes ==
      VK_EXTERNAL_MEMORY_HANDLE_TYPE_DMA_BUF_BIT_EXT);
   can_get_ahardware_buffer = (export_info && export_info->handleTypes ==
      VK_EXTERNAL_MEMORY_HANDLE_TYPE_ANDROID_HARDWARE_BUFFER_BIT_ANDROID);

   if (can_get_dmabuf_fd) {
      const VkMemoryGetFdInfoKHR get_fd_info = {
         .sType = VK_STRUCTURE_TYPE_MEMORY_GET_FD_INFO_KHR,
         .memory = *pMemory,
         .handleType =
            VK_EXTERNAL_MEMORY_HANDLE_TYPE_DMA_BUF_BIT_EXT,
      };
      result = device->dispatch_table.GetMemoryFdKHR(
         device->dispatch_handle, &get_fd_info, &memory->dmabuf_fd);
   } else if (can_get_ahardware_buffer) {
      const VkMemoryGetAndroidHardwareBufferInfoANDROID get_ahb_info = {
         .sType = VK_STRUCTURE_TYPE_MEMORY_GET_ANDROID_HARDWARE_BUFFER_INFO_ANDROID,
         .memory = *pMemory,
      };
      result = device->dispatch_table.GetMemoryAndroidHardwareBufferANDROID(
         device->dispatch_handle, &get_ahb_info, &memory->ahardware_buffer);
   }

   if (result != VK_SUCCESS) {
      wrapper_FreeMemory(_device, *pMemory, pAllocator);
      *pMemory = VK_NULL_HANDLE;
      return vk_error(device, result);
   }

   return VK_SUCCESS;
}

VKAPI_ATTR void VKAPI_CALL
wrapper_FreeMemory(VkDevice _device, VkDeviceMemory _memory,
                   const VkAllocationCallbacks* pAllocator)
{
   VK_FROM_HANDLE(wrapper_device, device, _device);
   struct wrapper_device_memory *memory;
   struct hash_entry *entry = NULL;

   entry = _memory != VK_NULL_HANDLE ? _mesa_hash_table_search(
      device->memorys, (void *)_memory) : NULL;
   memory = entry ? entry->data : NULL;

   if (memory) {
      if (memory->map_address && memory->map_size)
         munmap(memory->map_address, memory->map_size);
      if (memory->ahardware_buffer)
         AHardwareBuffer_release(memory->ahardware_buffer);
      if (memory->dmabuf_fd != -1)
         close(memory->dmabuf_fd);
      vk_free2(&device->vk.alloc, pAllocator, memory);
      _mesa_hash_table_remove(device->memorys, entry);
   }

   device->dispatch_table.FreeMemory(device->dispatch_handle,
                                     _memory,
                                     pAllocator);
}

VKAPI_ATTR VkResult VKAPI_CALL
wrapper_MapMemory2KHR(VkDevice _device,
                      const VkMemoryMapInfoKHR* pMemoryMapInfo,
                      void** ppData)
{
   VK_FROM_HANDLE(wrapper_device, device, _device);
   const VkMemoryMapPlacedInfoEXT *placed_info = NULL;
   struct wrapper_device_memory *memory;
   struct hash_entry *entry;
   int fd;

   if (pMemoryMapInfo->flags & VK_MEMORY_MAP_PLACED_BIT_EXT)
      placed_info = vk_find_struct_const(pMemoryMapInfo->pNext,
         MEMORY_MAP_PLACED_INFO_EXT);

   entry = pMemoryMapInfo->memory != VK_NULL_HANDLE
      ? _mesa_hash_table_search(device->memorys,
      (void *)pMemoryMapInfo->memory) : NULL;
   memory = entry ? entry->data : NULL;

   if (!placed_info || !memory) {
      return device->dispatch_table.MapMemory(
         device->dispatch_handle,
         pMemoryMapInfo->memory,
         pMemoryMapInfo->offset,
         pMemoryMapInfo->size,
         0,
         ppData);
   }

   if (memory->map_address) {
      if (placed_info->pPlacedAddress != memory->map_address) {
         return VK_ERROR_MEMORY_MAP_FAILED;
      } else {
         *ppData = (char *)memory->map_address
            + pMemoryMapInfo->offset;
         return VK_SUCCESS;
      }
   }
   assert(memory->dmabuf_fd >= 0 || memory->ahardware_buffer != NULL);

   if (memory->ahardware_buffer) {
      const native_handle_t *handle;
      const int *handle_fds;

      handle = AHardwareBuffer_getNativeHandle(memory->ahardware_buffer);
      handle_fds = &handle->data[0];

      int idx;
      for (idx = 0; idx < handle->numFds; idx++) {
         size_t size = lseek(handle_fds[idx], 0, SEEK_END);
         if (size >= memory->alloc_size) {
            break;
         }
      }
      assert(idx < handle->numFds);
      fd = handle_fds[idx];
   } else {
      fd = memory->dmabuf_fd;
   }

   if (pMemoryMapInfo->size == VK_WHOLE_SIZE)
      memory->map_size = memory->alloc_size > 0 ?
         memory->alloc_size : lseek(fd, 0, SEEK_END);
   else
      memory->map_size = pMemoryMapInfo->size;

   memory->map_address = mmap(placed_info->pPlacedAddress,
                              memory->map_size,
                              PROT_READ | PROT_WRITE,
                              MAP_SHARED | MAP_FIXED,
                              fd, 0);
   if (memory->map_address == MAP_FAILED) {
      memory->map_address = NULL;
      memory->map_size = 0;
      fprintf(stderr, "%s: mmap failed\n", __func__);
      return vk_error(device, VK_ERROR_MEMORY_MAP_FAILED);
   }

   *ppData = (char *)memory->map_address + pMemoryMapInfo->offset;

   return VK_SUCCESS;
}

VKAPI_ATTR void VKAPI_CALL
wrapper_UnmapMemory(VkDevice _device, VkDeviceMemory _memory) {
   vk_common_UnmapMemory(_device, _memory);
}

VKAPI_ATTR VkResult VKAPI_CALL
wrapper_UnmapMemory2KHR(VkDevice _device,
                        const VkMemoryUnmapInfoKHR* pMemoryUnmapInfo)
{
   VK_FROM_HANDLE(wrapper_device, device, _device);
   struct wrapper_device_memory *memory;
   struct hash_entry *entry;

   entry = pMemoryUnmapInfo->memory != VK_NULL_HANDLE ?
      _mesa_hash_table_search(device->memorys,
      (void *)pMemoryUnmapInfo->memory) : NULL;
   memory = entry ? entry->data : NULL;

   if (memory) {
      if (pMemoryUnmapInfo->flags & VK_MEMORY_UNMAP_RESERVE_BIT_EXT) {
         memory->map_address = mmap(memory->map_address, memory->map_size,
            PROT_NONE, MAP_PRIVATE | MAP_ANONYMOUS | MAP_FIXED, -1, 0);
         if (memory->map_address == MAP_FAILED) {
            fprintf(stderr, "Failed to replace mapping with reserved memory");
            return vk_error(device, VK_ERROR_MEMORY_MAP_FAILED);
         }
      } else {
         munmap(memory->map_address, memory->map_size);
      }

      memory->map_size = 0;
      memory->map_address = NULL;
   }

   device->dispatch_table.UnmapMemory(device->dispatch_handle,
                                      pMemoryUnmapInfo->memory);
   return VK_SUCCESS;
}

