#include <libusb-1.0/libusb.h>
#include <stdio.h>
#include <stdlib.h>
int main(int argc, char *argv[]) {
  if (argc != 2) {
    fprintf(stderr, "Usage: %s <usb_fd>\n", argv[0]);
    return 1;
  }
  int fd = atoi(argv[1]);
  libusb_device_handle *handle;
  libusb_set_option(NULL, LIBUSB_OPTION_NO_DEVICE_DISCOVERY);
  libusb_init(NULL);
  if (libusb_wrap_sys_device(NULL, (intptr_t)fd, &handle)) {
    fprintf(stderr, "Failed to wrap fd\n");
    return 1;
  }
  libusb_device *dev = libusb_get_device(handle);
  struct libusb_device_descriptor desc;
  if (libusb_get_device_descriptor(dev, &desc) != 0) {
    fprintf(stderr, "Failed to get device descriptor\n");
    return 1;
  }
  unsigned char manufacturer[256] = {0};
  unsigned char product[256] = {0};
  if (desc.iManufacturer)
    libusb_get_string_descriptor_ascii(handle, desc.iManufacturer, manufacturer,
                                       sizeof(manufacturer));
  if (desc.iProduct)
    libusb_get_string_descriptor_ascii(handle, desc.iProduct, product,
                                       sizeof(product));
  printf("%04x %04x \"%s\" \"%s\"\n", desc.idVendor, desc.idProduct, product,
         manufacturer);

  libusb_exit(NULL);
  return 0;
}
