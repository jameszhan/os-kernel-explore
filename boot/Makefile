
hello.asm:
	nasm hello.asm -o hello.bin

image: hello.asm
	dd if=hello.bin of=/dev/fd0 bs=512 count=1
	sync

all: image

clean:
	rm -f *.img *.bin *.o