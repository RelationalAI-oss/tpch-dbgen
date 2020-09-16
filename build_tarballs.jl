# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "tpch-dbgen"
version = v"0.0.5"

# Collection of sources required to build tpch-dbgen
sources = [
    ".",
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
pwd
ls -l 
cd dbgen-delve
make CC="$CC"
mkdir $prefix/tpch-dbgen
cp -R * $prefix/tpch-dbgen/

cd ../dbgen
make CC="$CC"
cp dbgen qgen $prefix/tpch-dbgen/
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64, libc=:glibc),
    MacOS(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    ExecutableProduct(prefix, "qgen-delve", :qgen_delve),
    ExecutableProduct(prefix, "dbgen-delve", :dbgen_delve)
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

