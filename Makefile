btsec.bin: btsec.asm func.asm testA20.asm
	nasm -fbin btsec.asm -o btsec.bin

run: btsec.bin
	qemu-system-x86_64 -drive format=raw,file=btsec.bin

clean:
	rm btsec.bin