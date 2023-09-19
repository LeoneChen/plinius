#!/bin/bash
set -e

for ARG in "$@"
do
   KEY="$(echo $ARG | cut -f1 -d=)"
   VAL="$(echo $ARG | cut -f2 -d=)"
   export "$KEY"="$VAL"
done

ROOT_CIR=$(realpath $(dirname $0))
SGXSAN_DIR=$(realpath ${ROOT_CIR}/../../install)
MAKE_FLAGS="CC=clang-13 CXX=clang++-13 LD=lld SGX_SDK=${SGXSAN_DIR} -j$(nproc) -Orecurse"
CMAKE_FLAGS=
MODE=${MODE:="RELEASE"}
FUZZER=${FUZZER:="LIBFUZZER"}
SIM=${SIM:="TRUE"}

echo "-- MODE: ${MODE}"
echo "-- FUZZER: ${FUZZER}"
echo "-- SIM: ${SIM}"

if [[ "${MODE}" = "DEBUG" ]]
then
    MAKE_FLAGS+=" SGX_DEBUG=1 SGX_PRERELEASE=0"
else
    MAKE_FLAGS+=" SGX_DEBUG=0 SGX_PRERELEASE=1"
fi

if [[ "${FUZZER}" = "KAFL" ]]
then
    MAKE_FLAGS+=" KAFL_FUZZER=1"
else
    MAKE_FLAGS+=" KAFL_FUZZER=0"
fi

if [[ "${SIM}" = "TRUE" ]]
then
    MAKE_FLAGS+=" SGX_MODE=SIM"
else
    MAKE_FLAGS+=" SGX_MODE=HW"
fi

make ${MAKE_FLAGS}
