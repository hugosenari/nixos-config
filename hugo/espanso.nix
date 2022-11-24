{ config, pkgs, lib, ... }:
let
  mapToList = keyAttr: obj: lib.attrsets.mapAttrsToList
  (name: value: { "${keyAttr}" = name; } // value) obj;
  nameToList = mapToList "name";
  outputVar = type: params: nameToList {
    output.type = type;
    output.params = params;
  };
  now = format: outputVar "date" { inherit format; };
  time = format: { replace = "{{output}}"; vars = now format; };
  resultOf = args: outputVar "script" { inherit args; };
in {
  services.espanso.enable = true;
  services.espanso.config.matches = mapToList "trigger" {
    "119".replace = "11981498025";
    "pss+".replace = "R4nd0m20O0@pa$S"; # std pass for tests
    "fulano".replace = "fulano da silva sauro";

    "!1" = time "%C%S%u";
    "!2" = time "%C%S%d";
    "!3" = time "%C%S%d%u";
    "!4" = time "%C%S%d%m";
    "!5" = time "%C%S%d%m%u";

    "age+" = time "%d%m%Y";
    "age0" = time "%d%m2020";
    "age1" = time "%d%m2010";
    "age2" = time "%d%m2000";
    "age3" = time "%d%m1990";
    "age4" = time "%d%m1980";
    "age5" = time "%d%m1970";

    "cep+" = time "%u%m%d%S%C";

    "hugo+".replace = "hugo+{{output}}@pontte.com.br";
    "hugo+".vars = now "%Y%m%d%H";
    "hugo@".replace = "hugo+{{output}}@pontte.com.br";
    "hugo@".vars = now "%Y%m%d%H%M";

    "hugosenari+".replace = "hugosenari+{{output}}@gmail.com";
    "hugosenari+".vars = now "%Y%m%d%H";
    "hugosenari@".replace = "hugosenari+{{output}}@gmail.com";
    "hugosenari@".vars = now "%Y%m%d%H%M";

    "cpf+".replace = "{{output}}";
    "cpf+".vars = resultOf [
      "/home/hugosenari/.nix-profile/bin/fish"
      "-c"
      "zzcpf"
    ];

    "cnpj+".replace = "{{output}}";
    "cnpj+".vars = resultOf [
      "/home/hugosenari/.nix-profile/bin/fish"
      "-c"
      "zzcnpj"
    ];
  };
}
