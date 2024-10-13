{ config, pkgs, lib, ... }:

{
  options.services.pipewire.rnnoise = {
    enable = lib.mkEnableOption "rnnoise filter for pipewire";
  };

  config =
    let
      cfg = config.services.pipewire.rnnoise;
    in
    lib.mkIf cfg.enable {
      services.pipewire.configPackages = [
        (pkgs.writeTextFile {
          name = "pipewire-source-rnnoise.conf";
          destination = "/share/pipewire/source-rnnoise.conf";
          text = builtins.toJSON {
            "context.properties" = { "log.level" = 0; };
            "context.spa-libs" = {
              "audio.convert.*" = "audioconvert/libspa-audioconvert";
              "support.*" = "support/libspa-support";
            };
            "context.modules" = [
              {
                name = "libpipewire-module-rtkit";
                args = {
                  "nice.level" = -11;
                  "rt.prio" = 88;
                  "rt.time.soft" = 2000000;
                  "rt.time.hard" = 2000000;
                };
                flags = [ "ifexists" "nofail" ];
              }
              { name = "libpipewire-module-protocol-native"; }
              { name = "libpipewire-module-client-node"; }
              { name = "libpipewire-module-adapter"; }

              {
                name = "libpipewire-module-filter-chain";
                args = {
                  "node.name" = "effect_input.rnnoise";
                  "node.description" = "Noise Canceling source";
                  "media.name" = "Noise Canceling source";
                  "filter.graph" = {
                    nodes = [
                      {
                        type = "ladspa";
                        name = "rnnoise";
                        plugin = "librnnoise_ladspa";
                        label = "noise_suppressor_stereo";
                        control = {
                          "VAD Threshold (%)" = 50.0;
                        };
                      }
                    ];
                  };
                  "capture.props" = {
                    "node.passive" = true;
                  };
                  "playback.props" = {
                    "media.class" = "Audio/Source";
                  };
                };
              }
            ];
          };
        })
      ];

      systemd.user.services."pipewire-rnnoise-source" = {
        environment = { LADSPA_PATH = "${pkgs.rnnoise-plugin}/lib/ladspa"; };
        description = "Noise canceling source for pipewire";
        requires = [ "pipewire.service" ];
        wantedBy = [ "pipewire.service" ];
        serviceConfig = {
          Restart = "on-failure";
        };
        script = "${pkgs.pipewire}/bin/pipewire -c source-rnnoise.conf";
        enable = true;
      };
    };
}
