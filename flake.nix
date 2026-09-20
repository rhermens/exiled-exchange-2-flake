{
  description = "Exiled Exchange 2, a Path of Exile 2 trading overlay";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, self }:
    let
      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          pname = "exiled-exchange-2";
          version = "0.16.3";

          src = pkgs.fetchurl {
            url = "https://github.com/Kvan7/Exiled-Exchange-2/releases/download/v${version}/Exiled-Exchange-2-${version}.AppImage";
            hash = "sha256-aAHFELdlL7cccpzAW9ROHF1hZDAnQGTLLtDonS0CT2Q=";
          };

          appimageContents = pkgs.appimageTools.extract {
            inherit pname version src;
          };
        in
        {
          default = pkgs.appimageTools.wrapType2 {
            inherit pname version src;

            extraInstallCommands = ''
              install -m 444 -D \
                ${appimageContents}/exiled-exchange-2.desktop \
                $out/share/applications/exiled-exchange-2.desktop
              substituteInPlace $out/share/applications/exiled-exchange-2.desktop \
                --replace-fail "Exec=AppRun --sandbox %U" "Exec=exiled-exchange-2 %U"
              cp -r ${appimageContents}/usr/share/icons $out/share/
            '';

            meta = {
              description = "Path of Exile 2 trading overlay for price checking";
              homepage = "https://github.com/Kvan7/Exiled-Exchange-2";
              license = pkgs.lib.licenses.mit;
              mainProgram = pname;
              platforms = [ "x86_64-linux" ];
              sourceProvenance = [ pkgs.lib.sourceTypes.binaryNativeCode ];
            };
          };
        }
      );

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/exiled-exchange-2";
          meta.description = "Launch Exiled Exchange 2";
        };
      });

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt-tree);
    };
}
