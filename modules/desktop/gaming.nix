{ pkgs, ... }:
{
  # Steam with Proton-GE
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];

    # Adds a "gamescope session" at login for big-picture style
    gamescopeSession.enable = true;
  };

  # Performance helpers.
  programs.gamemode.enable = true;   # CPU governor / niceness while gaming
  programs.gamescope.enable = true;  # micro-compositor: scaling, fps cap, fullscreen

  environment.systemPackages = with pkgs; [
    mangohud      # in-game stats overlay
    vulkan-tools  # vulkaninfo for debugging GPU
  ];
}
