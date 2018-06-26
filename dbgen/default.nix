{ stdenv }:
stdenv.mkDerivation {
  name = "tpch-dbgen-delve";
  src = ./.;
  makeFlags = "CC=cc";
  installPhase = ''
    mkdir -p $out/bin
    cp -R . $out/tpch
    ln -s $out/tpch/dbgen $out/bin/dbgen
    ln -s $out/tpch/qgen $out/bin/qgen
  '';
}
