{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-emoji
    font-awesome                # waybar default icon set
    nerd-fonts.jetbrains-mono   # glyphs for bar / launcher / prompt
  ];

  fonts.fontconfig.defaultFonts = {
    monospace = [ "JetBrainsMono Nerd Font" ];
    sansSerif = [ "Noto Sans" ];
    serif = [ "Noto Serif" ];
    emoji = [ "Noto Color Emoji" ];
  };
}
