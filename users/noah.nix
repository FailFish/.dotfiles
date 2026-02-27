{ inputs, ... }: {
  imports = [
    ./common/home.nix
  ];

  home.username = "noah";
  home.homeDirectory = "/Users/noah";

  accounts.email.accounts = {
    personal = {
      primary = true;
      aerc.enable = true;
      realName = "Taehyun Noh";
      address = "likeinstein42@gmail.com";
      flavor = "gmail.com";
    };
    utmail = {
      aerc.enable = true;
      realName = "Taehyun Noh";
      address = "taehyun@utexas.edu";
      flavor = "gmail.com";
    };
    # utcsmail = {
    #   address = "taehyun@cs.utexas.edu";
    #   flavor = "plain";
    #   folders = { };
    # };
    # gmail-us = {
    #   address = "this.taehyun@gmail.com";
    #   flavor = "gmail";
    #   folders = { };
    # };
  };

  programs.aerc = {
    enable = true;
    extraBinds = {};
    extraConfig = {
      general.unsafe-accounts-conf = true;
    };
    stylesets = {};
    templates = {};
  };
}
