{ stdenv }:
stdenv.mkDerivation {
  name = "tpch-dbgen-delve";
  src = ./.;
  makeFlags = "CC=cc";
  installPhase = ''
    mkdir -p $out/bin
    cp -R . $out/tpch
    cat > $out/bin/dbgen <<EOF
    #! /bin/sh
    cd $out/tpch
    exec ./dbgen \$@
    EOF
    cat > $out/bin/cgen <<EOF
    #! /bin/sh
    cd $out/tpch
    exec ./cgen \$@
    EOF
    chmod u+x $out/bin/*

  '';
}
