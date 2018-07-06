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
    cat > $out/bin/qgen <<EOF
    #! /bin/sh
    cd $out/tpch
    exec ./qgen \$@
    EOF
    chmod u+x $out/bin/*

  '';
}
