# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "tpch-dbgen"
version = v"0.0.10"

# Collection of sources required to build tpch-dbgen
sources = [
   DirectorySource("dbgen-rel", target="dbgen-rel"),
   DirectorySource("dbgen", target="dbgen"),
   DirectorySource("dbgen.JCC-H", target="dbgen.JCC-H"),
]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir
pwd
ls -l 
cd dbgen-rel
make CC="$CC"
mkdir $prefix/tpch-dbgen
cp -R * $prefix/tpch-dbgen/

cd ../dbgen
make CC="$CC"
cp dbgen qgen $prefix/tpch-dbgen/

cd ../dbgen.JCC-H
make CC="$CC"
cp dbgen-jcch qgen-jcch $prefix/tpch-dbgen/

# manually add .exe to Windows binaries
# remove this when we use a later version of BinaryBuilder
# https://juliapackaging.github.io/BinaryBuilder.jl/dev/reference/#BinaryBuilderBase.ExecutableProduct

if [[ $target = *mingw32* ]]; then
  mv $prefix/tpch-dbgen/dbgen $prefix/tpch-dbgen/dbgen.exe
  mv $prefix/tpch-dbgen/dbgen-rel $prefix/tpch-dbgen/dbgen-rel.exe
  mv $prefix/tpch-dbgen/dbgen-jcch $prefix/tpch-dbgen/dbgen-jcch.exe
  mv $prefix/tpch-dbgen/qgen $prefix/tpch-dbgen/qgen.exe
  mv $prefix/tpch-dbgen/qgen-rel $prefix/tpch-dbgen/qgen-rel.exe
  mv $prefix/tpch-dbgen/qgen-delve $prefix/tpch-dbgen/qgen-delve.exe
  mv $prefix/tpch-dbgen/qgen-jcch $prefix/tpch-dbgen/qgen-jcch.exe
fi
"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Platform("x86_64", "linux"; libc="glibc"),
    Platform("x86_64", "macos"),
    Platform("aarch64", "macos"),
    #Platform("x86_64", "windows")
]

# The products that we will ensure are always built
products = [
    ExecutableProduct("qgen-rel", :qgen_rel, "tpch-dbgen"),
    ExecutableProduct("dbgen-rel", :dbgen_rel, "tpch-dbgen"),
    ExecutableProduct("qgen-delve", :qgen_delve, "tpch-dbgen"),
    ExecutableProduct("qgen-jcch", :qgen_jcch, "tpch-dbgen"),
    ExecutableProduct("dbgen-jcch", :dbgen_jcch, "tpch-dbgen")
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies, require_license=false, julia_compat="1.7")

