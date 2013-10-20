#!/bin/sh
#/arch/arm/boot/mkimage -A arm -O linux -T script -C none -d <<name_of_your_script>> aml_autoscript
./mkimage -A arm -O linux -T script -C none -d $1 aml_autoscript
