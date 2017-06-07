#!/bin/bash
set -e

# Prototypes the use of seahorn toolchain
# with a source Rust program.
#
# Expected to be run from within the context of the source file, e.g. ./seahornrust.sh

# Assumes that seahorn has already been built.
# Assumes that Rust has been installed, and is on a version of LLVM
# that is supported by seahorn. As of initial checkin, 
# the "stable" version of "rustup" toolchain used LLVM 3.9.1
SOURCE_NAME="assignment"
MINIMAL_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
OUT_DIR="${MINIMAL_DIR}/out"


echo "Cleaning directories"
rm -rf "${OUT_DIR}"
mkdir -p "${OUT_DIR}"
cargo clean

# Build the Rust code, assuming that the lto option has been enabled for the dev profile
# in Cargo.toml
# Otherwise, would also add '-C lto' to the RUSTFLAGS
echo "Building Rust program to bitcode"
RUSTFLAGS='--emit=llvm-bc -A unused_variables -A unused_assignments' cargo build
SOURCE_NAME_PATTERN="${SOURCE_NAME}-*.bc"
COMPILED_BC="$(find ./target/debug/deps/ -name ${SOURCE_NAME_PATTERN} | xargs readlink -f)"
OUT_BC="${OUT_DIR}/${SOURCE_NAME}.bc"
cp "${COMPILED_BC}" "${OUT_BC}"

# Generate SMT-LIB file from LLVM Bitcode (BC)
echo "Generating SMT file"
OUT_SMT="${OUT_DIR}/${SOURCE_NAME}.smt2"
../../build/run/bin/sea horn --prove "${OUT_BC}" -o "${OUT_SMT}"  

