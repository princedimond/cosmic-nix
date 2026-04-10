{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    logseq
    github-copilot-cli
    joplin
    joplin-desktop
    joplin-cli
    television
  ];
}
