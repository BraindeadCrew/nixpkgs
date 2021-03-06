{ fetchurl, stdenv, pkgconfig, gnome3, python, sqlite
, intltool, libsoup, libxml2, libsecret, icu
, p11_kit, db, nspr, nss, libical, gperf, makeWrapper, valaSupport ? true, vala }:


stdenv.mkDerivation rec {
  name = "evolution-data-server-3.12.5";

  src = fetchurl {
    url = "mirror://gnome/sources/evolution-data-server/3.12/${name}.tar.xz";
    sha256 = "d3a2f832f823cb2a41467926dcaec984a15b2cb51ef89cf41267e337ca750811";
  };

  buildInputs = with gnome3;
    [ pkgconfig glib python intltool libsoup libxml2 gtk gnome_online_accounts libsecret
      gcr p11_kit db nspr nss libgweather libical libgdata gperf makeWrapper icu sqlite ]
    ++ stdenv.lib.optional valaSupport vala;

  # uoa irrelevant for now
  configureFlags = ["--disable-uoa" "--with-nspr-includes=${nspr}/include/nspr" "--with-nss-includes=${nss}/include/nss"]
                   ++ stdenv.lib.optional valaSupport "--enable-vala-bindings";

  preFixup = ''
    for f in "$out/libexec/"*; do
      wrapProgram "$f" --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
    done
  '';

  meta = with stdenv.lib; {
    platforms = platforms.linux;
    maintainers = [ maintainers.lethalman ];
  };

}
