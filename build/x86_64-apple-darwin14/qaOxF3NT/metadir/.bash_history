trap "save_env" EXIT
trap "save_env; save_srcdir" INT TERM ERR
set -e
tmpify_srcdir
cd $WORKSPACE/srcdir
pwd
ls -l
cd dbgen-delve
make CC="$CC"
mkdir $prefix/tpch-dbgen
cp -R * $prefix/tpch-dbgen/
cd ../dbgen
make CC="$CC"
make CC="$CC"
save_srcdir
make CC="$CC"
