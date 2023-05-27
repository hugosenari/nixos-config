{ config, lib, pkgs, ...}:
let
  otp    = pkgs.writeScriptBin "otp" ''
    #!${pkgs.bash}/bin/bash
    CLOAK_ACCOUNTS_DIR='${config.home.homeDirectory}/keybase/private/hugosenari/otp' \
    ${pkgs.cloak}/bin/cloak $@
  '';
  kbpass = pkgs.writeScriptBin "kbpass" ''
    #!${pkgs.nushell}/bin/nu
    # decrypt info from keybase key-value storage
    def kbpass-get [key: string] {
      { 
        method: get,
        params: {
          options: {
            namespace: ${config.home.username},
            entryKey:  $key
          }
        }
      }|to json|keybase kvstore api|from json|get result.entryValue
    }

    # insert encrypt value at keybase key-value storage
    def kbpass-set [key: string, secret: string] {
      { 
        method: put,
        params: {
          options: {
            namespace: ${config.home.username},
            entryKey:   $key,
            entryValue: $secret
          }
        }
      }|to json|keybase kvstore api
    }

    # copy info from keybase key-value storage
    def kbpass-copy [key: string] {
      kbpass $key | xclip -i
    }

    # list keys
    def kbpass-list [key: string] {
      { 
        method: list,
        params: {
          options: {
            namespace: ${config.home.username},
          }
        }
      }|to json|keybase kvstore api|from json|get result.entryKeys.entryKey|to text
    }

    # main
    def main [cmd = "", key = "", val = ""] {
      if $cmd == "get"  {
        kbpass-get  $key
      } else if $cmd == "set"  {
        kbpass-set  $key $val
      } else if $cmd == "copy" {
        kbpass-copy $key
      } else if $cmd == "list" {
        kbpass-list $key
      } else { 
        echo "try: kbpass list"
      }
    }
  '';
in
{
  home.packages = [ kbpass otp ];
}
