build:
	gcc -I gnu-efi -I gnu-efi/inc -I gnu-efi/inc/x86_64 -I gnu-efi/inc/protocol -Wno-error=pragmas -mno-red-zone -mno-avx -fpic  -g -O2 -Wall -Wextra -Werror -fshort-wchar -fno-strict-aliasing -ffreestanding -fno-stack-protector -fno-stack-check -fno-stack-check -fno-merge-all-constants -Wno-error=unused-parameter -Wno-error=unused-variable -DCONFIG_x86_64 -DGNU_EFI_USE_MS_ABI -maccumulate-outgoing-args --std=c11 -D__KERNEL__ -I /usr/src/sys/build/include -c main.c -o main.o
	ld -nostdlib --warn-common --no-undefined --fatal-warnings --build-id=sha1 -shared -Bsymbolic -Lgnu-efi/lib -Lgnu-efi/gnuefi gnu-efi/gnuefi/crt0-efi-x86_64.o main.o -o main.so -lefi -lgnuefi /usr/lib/gcc/x86_64-linux-gnu/9/libgcc.a -T gnu-efi/gnuefi/elf_x86_64_efi.lds
	objcopy -j .text -j .sdata -j .data -j .dynamic -j .dynsym -j .rel -j .rela -j .rel.* -j .rela.* -j .rel* -j .rela* -j .reloc --target efi-app-x86_64 main.so main.efi
	rm -r -f main.so main.o

install:
	apt-get install gcc xorriso grub-common qemu qemu-system ovmf mtools g++ nasm
	$(MAKE) -C gnu-efi
	$(MAKE) -C gnu-efi/gnuefi
	$(MAKE) -C gnu-efi/lib

uninstall:
	rm -r -f gnu-efi
