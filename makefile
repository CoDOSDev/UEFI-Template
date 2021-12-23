IMAGE = disk.img
ISO_IMAGE=disk.iso
BOOT_IMAGE = BOOTX64.EFI
KERNEL_IMAGE = kernel.elf
ALLOCATED_MEMORY = 256M

all: build run clean

build: Bootloader/main.efi Kernel/kernel.elf
	cp Bootloader/main.efi $(BOOT_IMAGE)
	cp Kernel/kernel.elf $(KERNEL_IMAGE)

	dd if=/dev/zero of=$(IMAGE) bs=1k count=1440

	mformat -i $(IMAGE) -f 1440 ::

	mmd -i $(IMAGE) ::/EFI
	mmd -i $(IMAGE) ::/EFI/BOOT

	mcopy -i $(IMAGE) $(BOOT_IMAGE) ::/EFI/BOOT
	mcopy -i $(IMAGE) Build/startup.nsh ::
	mcopy -i $(IMAGE) $(KERNEL_IMAGE) ::

Bootloader/main.efi:Bootloader/main.c
	$(MAKE) -C Bootloader

Kernel/kernel.elf:Kernel/src/kernel.cpp
	$(MAKE) -C Kernel

run:
	qemu-system-x86_64 -drive file=$(IMAGE) -m $(ALLOCATED_MEMORY) -cpu qemu64 \
	-drive if=pflash,format=raw,unit=0,file="Build/code.fd",readonly=on \
	-drive if=pflash,format=raw,unit=1,file="Build/vars.fd" \
	-net none

clean:
	rm -r -f $(BOOT_IMAGE) $(KERNEL_IMAGE)

buildiso:
	mkdir iso
	cp $(IMAGE) iso
	xorriso -as mkisofs -R -f -e $(IMAGE) -no-emul-boot -o $(ISO_IMAGE) iso
	rm -r -f iso