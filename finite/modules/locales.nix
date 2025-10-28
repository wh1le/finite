{ pkgs, ... }:
let
  defaultLocale = "en_US.UTF-8";
  extraLocales = = [ "en_US.UTF-8/UTF-8" ];
in
{

  i18n.extraLocaleSettings = {
    LC_ADDRESS = defaultLocale;
    LC_IDENTIFICATION = defaultLocale;
    LC_MEASUREMENT = defaultLocale;
    LC_MONETARY = defaultLocale;
    LC_NAME = defaultLocale;
    LC_NUMERIC = defaultLocale;
    LC_PAPER = defaultLocale;
    LC_TELEPHONE = defaultLocale;
    LC_TIME = defaultLocale;
    LC_MESSAGES = defaultLocale;
    LC_COLLATE = defaultLocale;
    LANGUAGE = defaultLocale;
    LC_ALL = defaultLocale;
    LC_CTYPE = defaultLocale;
  };

  i18n.extraLocales = extraLocales;
  i18n.defaultLocale = defaultLocale;

  environment.systemPackages = with pkgs; [ hunspellDicts.en_US ];
}
