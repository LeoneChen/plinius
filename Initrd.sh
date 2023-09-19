#!/bin/bash
set -e

for ARG in "$@"
do
   KEY="$(echo $ARG | cut -f1 -d=)"
   VAL="$(echo $ARG | cut -f2 -d=)"
   export "$KEY"="$VAL"
done

CUR_DIR=$(realpath .)
SGXSAN_DIR=$(realpath ${CUR_DIR}/../../)
MODE=${MODE:="RELEASE"}

echo "-- MODE: ${MODE}"

if [[ "${MODE}" = "DEBUG" ]]
then
    TARGET="target_debug"
else
    TARGET="target"
fi

${SGXSAN_DIR}/install/initrd/gen_initrd.sh ${CUR_DIR}/${TARGET}.cpio.gz ${CUR_DIR}/plinius ${CUR_DIR}/enclave.so ${SGXSAN_DIR}/install/rand_file ${SGXSAN_DIR}/install/bin/vmcall /usr/bin/addr2line /usr/bin/gdbserver
