{ config, pkgs, lib, ... }:

{
 
  home.username = "leons";
  home.homeDirectory = "/home/leons";

  home.stateVersion = "23.05"; # Please read the comment before changing.

  #keyboard config
  home.keyboard.layout = "us";
