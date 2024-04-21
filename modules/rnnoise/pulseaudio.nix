{ config, pkgs, lib, ... }:

{
  options.hardware.pulseaudio.rnnoise = {
    enable = lib.mkEnableOption "rnnoise filter for pulseaudio";

    source = lib.mkOption {
      description = ''
        Source to use as input for rnnoise.
      '';
      type = lib.types.nullOr lib.types.str;
    };

    extraLoopbackOptions = lib.mkOption {
      default = "";
      description = ''
        Additional options for the module-loopback and module-remap-source modules.
      '';
      example = "channels=2";
      type = lib.types.separatedString " ";
    };

    setAsDefaultSource = lib.mkOption {
      default = false;
      description = ''
        Whether to set the denoised source as default.
      '';
      example = true;
      type = lib.types.bool;
    };
  };

  config =
    let
      cfg = config.hardware.pulseaudio.rnnoise;
    in
    lib.mkIf cfg.enable {
      hardware.pulseaudio.extraConfig = ''
        load-module module-null-sink sink_name=mic_denoised_out rate=44100
        load-module module-ladspa-sink sink_name=mic_raw_in sink_master=mic_denoised_out label=noise_suppressor_stereo plugin=${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so control=50
        load-module module-loopback source=${assert cfg.source != null; cfg.source} sink=mic_raw_in ${cfg.extraLoopbackOptions} source_dont_move=true sink_dont_move=true latency_msec=1
        load-module module-remap-source source_name=denoised master=mic_denoised_out.monitor ${cfg.extraLoopbackOptions}

        ${lib.optionalString cfg.setAsDefaultSource "set-default-source denoised"}
      '';
    };
}
