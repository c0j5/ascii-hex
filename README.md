# ascii-hex

## Description
This program converts hexadecimal bytes from `inputBuf` into their ASCII representation and prints them to the screen. Two versions are included:
1. **Main Version**: Direct conversion in main loop
2. **Extra Credit Version**: Uses a dedicated subroutine for nibble-to-ASCII conversion

## Requirements
- Linux environment
- NASM (Netwide Assembler)
- ld (GNU Linker)
- 32-bit libraries (for 64-bit systems)

## Installation (For 64-bit Systems)
```bash
sudo apt-get update
sudo apt-get install nasm
sudo apt-get install gcc-multilib  # For 32-bit support
