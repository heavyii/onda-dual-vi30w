amlogic m3芯片会按顺序选择启动设备，当裸板时要想写系统到nandflash中就要从tf卡启动了。做可启动tf卡的方法是：
卡分区：
1)使用fdisk工具进行分区，我们需要分两个分区,同时预留一部分放置uboot,可以理解为分3个分区
– 我们需要进入linux系统,用fdisk工具进行操作
– 先用fdisk工具将卡里原有的分区删除
 用fdisk工具对卡重新分区,注意第一个分区最好不要从第一个sector开始,预留一部分空间用来放置uboot
$ sudo fdisk -l     //查看卡分区列表
$ sudo fdisk /dev/<your sdcard,for example sdd>  //进入卡区
Command (m for help): p                  //显示此行时选择 P 可再次查看卡分区列表
Command (m for help): d                   //删除当前卡分区
Command (m for help): n                   //创建卡新分区    
Command (m for help): t                   //更改卡分区系统格式
Command (m for help): w                   //更改卡分区系统格式
$ sudo mkfs.msdos /dev/sdd1               //格式化卡分区fat32
$ sudo mkfs.ext3 /dev/sdd2                //格式化卡分区linux

2)拷贝U-BOOT到卡第一分区
首先指定.bin文档路径
sudo dd if=./u-boot-aml-ucl.bin of=/dev/sdf bs=1 count=442
sudo dd if=./u-boot-aml-ucl.bin of=/dev/sdf bs=512 skip=01 seek=1
注意：由于分区表位于446开始处总共占用64个字节所以上面的两条dd命令不会影响到tf卡的分区。
3)将编译生成的文件uImage uImage_recovery f04ref-ota-eng.leo.zip放入fat32分区
3.通过上一步就完成了一个可启动的tf卡，插入tf卡然后启动板子，进入uboot的命令行模式，通过一下两条命令启动到recovery模式
fatload mmc 0 82000000 uImage_recovery
bootm
然后选择f04ref-ota-eng.leo.zip进行recovery升级就完成了系统的刷入。

part1: fat32分区
part2: system分区
part3: data分区
part4: SD分区

heavey@heavey-ThinkPad-T420:~/amlogic/test2$ sudo fdisk /dev/sdb
Command (m for help): p

Disk /dev/sdb: 7948 MB, 7948206080 bytes
245 heads, 62 sectors/track, 1021 cylinders, total 15523840 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000362

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1           22048      284191      131072   83  Linux 
/dev/sdb2          284192     2381343     1048576   83  Linux
/dev/sdb3         2381344     4478495     1048576   83  Linux
/dev/sdb4         4478496    15523839     5522672   83  Linux

