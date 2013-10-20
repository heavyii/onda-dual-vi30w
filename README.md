
# SD卡运行android

onda vi30w 双核板 的flash坏了，只能把android放到SD卡去运行，简单修改init.rc和vold.fstab即可。

## 文件说明

vi30w-dual-v2-155-boot.img是固件v155的update里的boot.img

## 解压内核与ramdisk文件系统

	sh unpack-uImage.sh vi30w-dual-v2-155-boot.img 

## 修改initramfs/init.rc

修改文件系统挂着，挂载sd卡

	on fs
		ubiattach mtd@system
		mount ubifs ubi0_0 /system
		ubiattach mtd@userdata
		mount ubifs ubi1_0 /data nosuid nodev
		mount yaffs2 mtd@cache /cache nosuid nodev

改成

	on fs
		mount ext3 /dev/block/cardblksd2 /system 
		chmod -R a+rw /system
		mount ext3 /dev/block/cardblksd3 /data 
		mount tmpfs tmpfs /cache

## 挂载SD卡到/mnt/sdcard

修改/system/etc/vold.fstab

dev_mount sdcard /mnt/sdcard 4 /devices/platform/AMLOGIC_CARD/card_host/memorycard0 /devices/platform/aml_sd_mmc.0

删除flash的挂载

## 支持adb shell

在/system/bin目录创建sh软链接到/system/xbin/busybox

	cp system/xbin/busybox system/bin
	cd system/bin
	ln -s busybox sh


## 制作aml_autoscript

mkimage在linux目录的arch/arm/boo/mkimage

	sh mkscript.sh linux.auto.txt
	sh mkscript.sh android.auto.txt

## vi30w 硬件

	AXP202
	AML-RT5631
	Sensor MMA7660
	[GSL1680] Enter gsl_ts_init_ts
	input: gsl1680 as /devices/i2c-0/0-0040/input/input5

	gc0307 0-0021: chip found @ 0x42 (aml_i2c_adap0)
	[    3.825101] ADC Keypad Driver init.
	[    3.828289] chan #4 used for ADC key
	[    3.831900] menu key(139) registed.
	[    3.835278] back key(158) registed.
	[    3.838749] home key(102) registed.
	Key 116 registed.

