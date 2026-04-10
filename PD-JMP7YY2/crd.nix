{ config, lib, pkgs, ...}: 
with lib;
    let 
        cfg = config.services.crd;
    in {
        options = {
            services.crd = {
                enable = mkEnableOption ''
                    chrome remote desktop, a service which allows for remote control of your desktop from anywhere.
                '';
                user = mkOption {
                    type = types.submodule;
                    description = ''
                        A user which the service will run as.
                    '';
                    example = "users.users.alice";
                };
                screenSize = mkOption {
                    type = types.string;
                    description = ''
                        Size of the screen (for all clients)
                    '';
                    default = "1366x768";
                    example = "1920x1080";
                };
                session = mkOption {
                    type = types.string;
                    description = ''
                        The X session that chrome remote desktop will control
                    '';
                    example = "gnome-session";
                };
            };
        };
        config = mkIf cfg.enable {
            systemd.services.chrome-remote-desktop = {
                description = "Chrome remote desktop service";
                path = with pkgs; [ sudo chrome-remote-desktop ];
                script = ''
                    sudo -u ${cfg.user.name} ${pkgs.chrome-remote-desktop}/opt/google/chrome-remote-desktop --start --size=${cfg.screenSize}
                '';
            };
            security.wrappers.crd-user-session.source = "${pkgs.chrome-remote-desktop}/opt/google/chrome-remote-desktop/user-session";
            system.activationScripts.crd-setup = {
                text = ''
                    if [[ -z $(cat ${cfg.user.home}/.chrome-remote-desktop-session) ]]; then
                        # Create the file
                        echo "export $(dbus-launch)" > ${cfg.user.home}/.chrome-remote-desktop-session
                        echo "exec ${cfg.session}" >> ${cfg.user.home}/.chrome-remote-desktop-session
                    fi
                '';
            };
        };
    }