#!/bin/sh
echo 0 > /proc/sys/kernel/randomize_va_space
cat /proc/sys/kernel/randomize_va_space 2>&1 | vmcall hcat
cd fuzz
# ifconfig eth0 10.0.2.15 2>&1 | vmcall hcat
# ip addr 2>&1 | vmcall hcat
# ./gdbserver 127.0.0.1:1234 ./plinius --cb_enclave=enclave.so | vmcall hcat
./plinius --cb_enclave=enclave.so | vmcall hcat
