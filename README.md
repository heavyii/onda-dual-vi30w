
# SD卡运行android

onda vi30w 双核板 的flash坏了，只能把android放到SD卡去运行，简单修改init.rc和vold.fstab即可。

## 文件说明

vi30w-dual-v2-155-boot.img是固件v155的update里的boot.img

## 解压内核与ramdisk文件系统

	sh unpack-uImage.sh vi30w-dual-v2-155-boot.img 

## 

