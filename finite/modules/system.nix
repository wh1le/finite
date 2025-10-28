{pkgs, USERNAME, ...}
:
{

  services.displayManager.enable = false;
  services.getty.autologinUser = USERNAME;

  console = {
    packages = [ pkgs.terminus_font ];
    font = "ter-v32n";
    keyMap = "us";
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableBashCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;
    histSize = 10000;
    ohMyZsh = {
      enable = true;
      plugins = [ "git" "dirhistory" "history" ];
    };
  };
  users.users.${USERNAME}.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    git
    tmux

    nano
    neovim

    htop
    btop

    # Net
    dig
    nmap

    nettools
    iputils
    unzip
    usbutils
  ];
}
