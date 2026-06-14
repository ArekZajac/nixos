{ ... }:
{
  # PipeWire audio stack
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true; # for Steam / 32-bit games
    pulse.enable = true;      # PulseAudio-compatible server
    wireplumber.enable = true;
  };
}
