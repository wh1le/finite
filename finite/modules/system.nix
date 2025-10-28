{pkgs, USERNAME, ...}
:
{

  services.displayManager.enable = false;
  services.getty.autologinUser = USERNAME;

  console = {
    packages = [ pkgs.terminus_font ];
    font = "ter-v22n";
    keyMap = "us";
  };

  programs.zsh.enable = true;
  users.users.${USERNAME}.shell = pkgs.zsh;

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
