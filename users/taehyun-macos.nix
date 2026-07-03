{ inputs, config, ... }: {
  imports = [
    ./common/home.nix
  ];

  home.username = "taehyun";
  home.homeDirectory = "/Users/taehyun";
  home.sessionVariables = {
    SSH_AUTH_SOCK="${config.home.homeDirectory}/.bitwarden-ssh-agent.sock";
  };
}
