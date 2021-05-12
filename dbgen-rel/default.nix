{ stdenv }:
stdenv.mkDerivation {
  name = "tpch-dbgen-delve";
  src = ./.;
  makeFlags = "CC=cc MACHINE=${if stdenv.isDarwin then "MAC" else "LINUX"}";
  installPhase = ''
    mkdir -p $out/bin
    cp -R . $out/tpch
    cat > $out/bin/dbgen-delve <<EOF
    #! /bin/sh
    cd $out/tpch
    exec ./dbgen-delve \$@
    EOF
    cat > $out/bin/qgen-delve <<EOF
    #! /bin/sh
    cd $out/tpch
    exec ./qgen-delve \$@
    EOF
    chmod u+x $out/bin/*
  '';
}
