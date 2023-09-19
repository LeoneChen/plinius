#!/bin/bash
CUR_DIR=$(realpath .)
SGXSAN_DIR=$(realpath ${CUR_DIR}/../../)

source ${SGXSAN_DIR}/kAFL/kafl/env.sh
kafl fuzz -w ${CUR_DIR}/workdir_T0 --kernel /home/leone/Documents/linux/arch/x86_64/boot/bzImage --initrd ${CUR_DIR}/target.cpio.gz --memory 512 --sharedir ${CUR_DIR}/sharedir --seed-dir ${CUR_DIR}/seeds -t 4 -ts 2 -tc -p 1 --redqueen --grimoire --radamsa -D --funky --purge --log-hprintf --abort-time 24 --cpu-offset 0
# kafl debug --action single -w ${CUR_DIR}/workdir1 --kernel /home/leone/Documents/linux/arch/x86_64/boot/bzImage --initrd ${CUR_DIR}/target.cpio.gz --memory 512 --sharedir ${CUR_DIR}/sharedir --purge --qemu-base "-enable-kvm -machine kAFL64-v1 -cpu kAFL64-Hypervisor-v1,+vmx -no-reboot -nic user,hostfwd=tcp::5555-:1234 -display none" -t 200 --input $1
# kafl cov --kernel /mnt/hdd/chenliheng/linux/arch/x86_64/boot/bzImage --initrd ${CUR_DIR}/target.cpio.gz --memory 512 --sharedir ${CUR_DIR}/sharedir -r -ip0 0x10000-0x7ffffffff000 -t 4 -w ${CUR_DIR}/workdir_T0 -p16
# ${SGXSAN_DIR}/kAFL/kafl/fuzzer/scripts/ghidra_run.sh ${CUR_DIR}/workdir_T0 ${CUR_DIR}/enclave.so ${SGXSAN_DIR}/ghidra_cov_analysis.py
