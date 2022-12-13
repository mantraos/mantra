set -e

rm -rf .build
mkdir .build
cd .build

BIN=mantrakernel
curl -O https://github.com/mantraos/mantra/blob/main/.mantra/mantrakernel?raw=true

cp mantrakernel?raw=true mantrakernel
rm mantrakernel?raw=true

chmod +x $BIN

mkdir out

# workaround fs bug in HolyCRT (fails to create necessary directories)
mkdir -p out/Compiler out/Kernel

env STARTOS=Build/BuildMantra ./$BIN --drive=C,..,out

ISO_FILE=Mantra.out/Mantra.ISO
ISO_SIZE=$(wc -c <$ISO_FILE)
MIN_SIZE=100000
if [ $ISO_SIZE -le $MIN_SIZE ]; then
    echo error: $ISO_FILE is $ISO_SIZE bytes in size, less than the expected minimum of $MIN_SIZE >&2
    exit 1
fi
