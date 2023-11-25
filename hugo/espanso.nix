{ config, pkgs, lib, ... }:
let
  mapToList  = keyAttr: obj: lib.attrsets.mapAttrsToList
  (name: value: { "${keyAttr}" = name; } // value) obj;
  nameToList = mapToList "name";
  outputVar  = type: params: nameToList {
    output.type = type;
    output.params = params;
  };
  now        = format: outputVar "date"   { inherit format; };
  resultOf   = args:   outputVar "script" { inherit args;   };
  time       = format: { replace = "{{output}}"; vars = now format; };
  otp        = suffix: { replace = "{{output}}"; vars = resultOf ["${bin}/otp"    "view" suffix]; };
  kbp        = suffix: { replace = "{{output}}"; vars = resultOf ["${bin}/bkpass" "get"  suffix]; };
  bin        = "/etc/profiles/per-user/hugosenari/bin";
  triggers   = mapToList "trigger" {
    "119".replace    = "11981498025";
    "pss+".replace   = "R4nd0m20O0@pa$S"; # std pass for tests
    "fulano".replace = "fulano da silva sauro";

    "!1"   = time "%C%S%u";
    "!2"   = time "%C%S%d";
    "!3"   = time "%C%S%d%u";
    "!4"   = time "%C%S%d%m";
    "!5"   = time "%C%S%d%m%u";

    "age+" = time "%d%m%Y";
    "age0" = time "%d%m2020";
    "age1" = time "%d%m2010";
    "age2" = time "%d%m2000";
    "age3" = time "%d%m1990";
    "age4" = time "%d%m1980";
    "age5" = time "%d%m1970";

    "cep+" = time "%u%m%d%S%C";

    "hugosenari+".replace = "hugosenari+{{output}}@gmail.com";
    "hugosenari+".vars    = now "%Y%m%d%H";

    "otpaltice"           = otp "altice";
    "otpbinance"          = otp "binance";
    "otpcoinbase"         = otp "coinbase";
    "otpcoinbebe"         = otp "coinbebe";
    "otpgithub"           = otp "github";
    "otpgooglealtice"     = otp "google-altice";
    "otphusky"            = otp "husky";
    "otpkraken"           = otp "kraken";
    "otpmercadobitcoin"   = otp "mercado-bitcoin";
    "otpmercadolivre"     = otp "mercado-livre";
    "otptabtrader"        = otp "tabtrader";
    "otptest"             = otp "test";
    "otpwibx"             = otp "wibx";
    "otpzoho"             = otp "zoho";

    "kbpght"  = kbp "github-token";
  };
in {
  services.espanso.enable = true;
  services.espanso.matches.base.matches = triggers;
}
