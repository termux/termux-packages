#include <algorithm>
#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

#ifdef __APPLE__
# include "elf.h"
#else
# include <elf.h>
#endif

#define DT_VERNEEDED 0x6ffffffe
#define DT_VERNEEDNUM 0x6fffffff

template<typename ElfHeaderType /*Elf{32,64}_Ehdr*/,
	 typename ElfSectionHeaderType /*Elf{32,64}_Shdr*/,
	 typename ElfDynamicSectionEntryType /* Elf{32,64}_Dyn */>
bool process_elf(uint8_t* bytes, size_t elf_file_size)
{
	if (sizeof(ElfSectionHeaderType) > elf_file_size) {
		fprintf(stderr, "ERROR: Elf header would end at %zu but file size only %zu\n", sizeof(ElfSectionHeaderType), elf_file_size);
		return false;
	}
	ElfHeaderType* elf_hdr = reinterpret_cast<ElfHeaderType*>(bytes);

	size_t last_section_header_byte = elf_hdr->e_shoff + sizeof(ElfSectionHeaderType) * elf_hdr->e_shnum;
	if (last_section_header_byte > elf_file_size) {
		fprintf(stderr, "ERROR: Section header would end at %zu but file size only %zu\n", last_section_header_byte, elf_file_size);
		return false;
	}
	ElfSectionHeaderType* section_header_table = reinterpret_cast<ElfSectionHeaderType*>(bytes + elf_hdr->e_shoff);

	for (unsigned int i = 1; i < elf_hdr->e_shnum; i++) {
		ElfSectionHeaderType* section_header_entry = section_header_table + i;
		if (section_header_entry->sh_type == SHT_DYNAMIC) {
			size_t const last_dynamic_section_byte = section_header_entry->sh_offset + section_header_entry->sh_size;
			if (last_dynamic_section_byte > elf_file_size) {
				fprintf(stderr, "ERROR: Dynamic section would end at %zu but file size only %zu\n", last_dynamic_section_byte, elf_file_size);
				return false;
			}

			size_t const dynamic_section_entries = section_header_entry->sh_size / sizeof(ElfDynamicSectionEntryType);
			ElfDynamicSectionEntryType* const dynamic_section =
				reinterpret_cast<ElfDynamicSectionEntryType*>(bytes + section_header_entry->sh_offset);

			unsigned int last_nonnull_entry_idx = 0;
			for (unsigned int j = dynamic_section_entries - 1; j > 0; j--) {
				ElfDynamicSectionEntryType* dynamic_section_entry = dynamic_section + j;
				if (dynamic_section_entry->d_tag != DT_NULL) {
					last_nonnull_entry_idx = j;
					break;
				}
			}

			for (unsigned int j = 0; j < dynamic_section_entries; j++) {
				ElfDynamicSectionEntryType* dynamic_section_entry = dynamic_section + j;
				switch (dynamic_section_entry->d_tag) {
					case DT_VERNEEDED:
					case DT_VERNEEDNUM:
					case DT_RPATH:
					case DT_RUNPATH:
						char const* removed_name;
						switch (dynamic_section_entry->d_tag) {
							case DT_VERNEEDED: removed_name = "DT_VERNEEDED"; break;
							case DT_VERNEEDNUM: removed_name = "DT_VERNEEDNUM"; break;
							case DT_RPATH: removed_name = "DT_RPATH"; break;
							case DT_RUNPATH: removed_name = "DT_RUNPATH"; break;
						}
						printf("Removing the %s dynamic section entry\n", removed_name);
						// Tag the entry with DT_NULL and put it last:
						dynamic_section_entry->d_tag = DT_NULL;
						// Decrease j to process new entry index:
						std::swap(dynamic_section[j--], dynamic_section[last_nonnull_entry_idx--]);
						break;
				}
			}
		}
	}
	return true;
}


int main(int argc, char **argv)
{
	if (argc < 2 || (argc == 2 && strcmp(argv[1], "-h")==0)) {
		fprintf(stderr, "usage: %s <filename>\n", argv[0]);
		fprintf(stderr, "       Processes ELF files to remove DT_VERNEEDED, DT_VERNEEDNUM, DT_RPATH\n"
				"       and DT_RUNPATH entries (which the Android linker warns about)\n");
		return 1;
	}

	for (int i = 1; i < argc; i++) {
		int fd = open(argv[i], O_RDWR);
		if (fd < 0) { perror("open()"); return 1; }

		struct stat st;
		if (fstat(fd, &st) < 0) { perror("fstat()"); return 1; }

		if (st.st_size < (long long) sizeof(Elf32_Ehdr)) continue;

		void* mem = mmap(0, st.st_size, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
		if (mem == MAP_FAILED) { perror("mmap()"); return 1; }

		uint8_t* bytes = reinterpret_cast<uint8_t*>(mem);
		if (!(bytes[0] == 0x7F && bytes[1] == 'E' && bytes[2] == 'L' && bytes[3] == 'F')) {
			munmap(mem, st.st_size);
			close(fd);
			continue;
		}

		uint8_t bit_value = bytes[4];
		if (!(bit_value == 1 || bit_value == 2)) {
			printf("ERROR: Incorrect bit value: %d\n", bit_value);
			return 1;
		} else if (bit_value == 1) {
			if (!process_elf<Elf32_Ehdr, Elf32_Shdr, Elf32_Dyn>(bytes, st.st_size)) return 1;
		} else {
			if (!process_elf<Elf64_Ehdr, Elf64_Shdr, Elf64_Dyn>(bytes, st.st_size)) return 1;
		}

		if (msync(mem, st.st_size, MS_SYNC) < 0) { perror("msync()"); return 1; }

		munmap(mem, st.st_size);
		close(fd);
	}
	return 0;
}

