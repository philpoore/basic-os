

all: clean build vm

build: make_image build_src burn_image

vm: poweroff_vm unmount_floppy mount_floppy poweron_vm



make_image:
	- mkdir dist/
	dd bs=512 count=2880 if=/dev/zero of=dist/image.img

build_src:
	- mkdir build/
	nasm src/boot.asm -f bin -o build/boot.bin

burn_image:
	dd if=build/boot.bin bs=512 of=dist/image.img




poweroff_vm:
	- VBoxManage showvminfo dos | grep "State:" | grep "running" && echo "Powering Off" && VBoxManage controlvm dos poweroff

poweron_vm:
	- VBoxManage showvminfo dos | grep "State:" | grep "off" && echo "Powering On" && VBoxManage startvm dos

unmount_floppy:
	- VBoxManage storageattach dos --storagectl 'Floppy' --device 0 --port 0 --medium none

mount_floppy:
	- VBoxManage storageattach dos --storagectl 'Floppy' --device 0 --port 0 --medium `pwd`/dist/image.img

clean:
	- rm -rf build/
	- rm -rf dist/