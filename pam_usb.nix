# this isn't my code, copy from here 
# https://discourse.nixos.org/t/creating-overlay-for-pam-usb/31600
{

  security.pam.usb.enable = true;
  services.udisks2.enable = true;
  security.pam.services.lightdm-greeter.usbAuth = true;
  nixpkgs.overlays        = [( final: prev: with final; {
    pam_usb =
      let
        # Search in the environment if the same program exists with a set uid or
        # set gid bit.  If it exists, run the first program found, otherwise run
        # the default binary.
        useSetUID = drv: path:
          let
            name = baseNameOf path;
            bin = "${drv}${path}";
          in assert name != "";
            writeScript "setUID-${name}" ''
              #!${runtimeShell}
              inode=$(stat -Lc %i ${bin})
              for file in $(type -ap ${name}); do
                case $(stat -Lc %a $file) in
                  ([2-7][0-7][0-7][0-7])
                    if test -r "$file".real; then
                      orig=$(cat "$file".real)
                      if test $inode = $(stat -Lc %i "$orig"); then
                        exec "$file" "$@"
                      fi
                    fi;;
                esac
              done
              exec ${bin} "$@"
            '';
        pmountBin  = useSetUID pmount "/bin/pmount";
        pumountBin = useSetUID pmount "/bin/pumount";
        pythonPkgs = python3.withPackages (p: [ p.pygobject3 p.gst-python p.lxml ]);
      in
      stdenv.mkDerivation {
        pname = "pam_usb";
        src     = fetchFromGitHub {
          hash  = "sha256-oSZ0+Cphy1+h6qn8IVKiv91+IhqUUOFnr+Ya+G+wPH0=";
          owner = "mcdope";
          repo  = "pam_usb";
          rev   = "2eeaaff4caf5c85dd1f4858f5f2b8caedd665455";
        };
        version = "master";
      
        nativeBuildInputs = [
          makeWrapper
          wrapGAppsHook
          gobject-introspection
          pkg-config
        ];
      
        buildInputs =           [ libxml2 udisks2 pam dbus pmount glib ];
        propagatedBuildInputs = [ udisks2 pythonPkgs ];

        preFixup = ''
          makeWrapperArgs+=("''${gappsWrapperArgs[@]}")
        '';
      
        preBuild = ''
          makeFlagsArray=(DESTDIR=$out)
          substituteInPlace ./src/volume.c \
            --replace 'pmount'  '${pmountBin}' \
            --replace 'pumount' '${pumountBin}'
        '';
      
        # pmount is append to the PATH because pmounts binaries should have a set uid bit.
        postInstall = ''
          mv $out/usr/* $out/. # fix color */
          rm -rf $out/usr
          for prog in $out/bin/pamusb-conf $out/bin/pamusb-agent; do
            substituteInPlace $prog --replace '/usr/bin/env python' '/bin/python'
            wrapProgram $prog \
              --prefix PYTHONPATH : "$(toPythonPath ${pythonPkgs})"
          done
        '';
      
        meta = {
          description = "Authentication using USB Flash Drives";
          homepage    = "http://pamusb.org/";
          license     = lib.licenses.gpl2;
          platforms   = lib.platforms.linux;
        };
      };
  })];
}
