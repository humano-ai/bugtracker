Title: Reduce floppy disk size after formatting
Author: rodarima
Created: Sat, 29 Jun 2024 14:40:21 +0000
State: closed

The useful space to store files inside a floppy is less than the capacity of the floppy itself:
```
  % mkfs.msdos -C floppy.img 1440
  mkfs.fat 4.2 (2021-01-31)
  % stat -c %s floppy.img
  1474560
  % mkdir floppy
  % sudo mount -o loop,uid=$USER floppy.img floppy
  % dd if=/dev/zero bs=1 count=100M of=floppy/test
  dd: error writing 'floppy/test': No space left on device
  1457665+0 records in
  1457664+0 records out
  1457664 bytes (1,5 MB, 1,4 MiB) copied, 0,912079 s, 1,6 MB/s
  % echo $((1474560 - 1457664))
  16896
```
It needs a bit more than 16K to store the FAT table, so round it to 32K to allow some clearance for changes in FAT header size.
```
  % echo $((1474560 - 32*1024))
  1441792
```