

all: clean make_image build burn_image


make_image:
	mkdir dist/
	dd bs=512 count=2880 if=/dev/zero of=dist/image.img

build:
	mkdir build/
	nasm src/boot.asm -f bin -o build/boot.bin

burn_image:
	dd if=build/boot.bin bs=512 of=dist/image.img

clean:
	rm -rf build/
	rm -rf dist/