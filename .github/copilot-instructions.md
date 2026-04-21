# Copilot Instructions - cosmic-nix

This is a **NixOS system configuration repository** using Nix flakes for declarative, reproducible system management. It's organized around multiple host machines, each with its own configuration directory.

## Repository Structure

- **PD-BRFMF72/, PD-G4BK722/, PD-JMP7YY2/**: Host-specific configuration directories (each is a complete NixOS + home-manager setup)
- **flake.nix** (root level or in host dir): Defines NixOS system configuration, inputs (nixpkgs, home-manager, cosmic-manager, etc.), and outputs
- **configuration.nix** (per-host): System-wide settings (bootloader, networking, services, system packages)
- **home.nix** (per-host): User-level configuration via home-manager (programs, environment variables, dotfiles)
- **hardware-configuration.nix** (per-host): Auto-generated hardware config; do NOT edit manually
- **host-apps.nix** (per-host): Additional host-specific system packages
- **evil-helix.nix** (per-host): Helix editor configuration
- **gtk.nix** (per-host): GTK theme and appearance settings
- **WARP.md** (per-host): Comprehensive guide with build/test commands and troubleshooting

## Build, Test, and Lint Commands

### Building Configuration
```bash
# Dry-run (check for errors without applying)
sudo nixos-rebuild dry-build --flake .#HOSTNAME

# Apply configuration
sudo nixos-rebuild switch --flake .#HOSTNAME

# Test without making default boot option
sudo nixos-rebuild test --flake .#HOSTNAME
```

### Flake Management
```bash
# Check flake syntax
nix flake check

# Update all inputs
nix flake update

# Update specific input (e.g., nixpkgs)
nix flake update nixpkgs

# Show flake outputs
nix flake show
```

### Node Packages (if modifying node-packages.json)
```bash
# Regenerate Nix expressions for Node.js packages
node2nix -i node-packages.json -o node-packages.nix -c node-env.nix
```

### System Cleanup
```bash
# Clean up old generations
sudo nix-collect-garbage --delete-older-than 7d

# Force garbage collection
sudo nix-collect-garbage -d
```

## Architecture Overview

### Key Inputs (flake.nix)
- **nixpkgs** (nixos-unstable): Main NixOS package repository
- **home-manager**: User dotfile and environment management
- **cosmic-manager**: COSMIC desktop environment configuration
- **zen-browser**: Alternative web browser
- **nixvim**: Neovim configuration
- **nix-flatpak**: Flatpak integration for system
- **catppuccin**: Theme and color scheme library
- **disko**: Declarative disk partitioning

### Desktop Environment
- **COSMIC**: The primary desktop environment (not GNOME)
- **cosmic-greeter**: Display manager for COSMIC
- **cosmic-manager**: Flake input for COSMIC-specific home-manager module

### Configuration Pattern
Each host config follows this structure:
1. **flake.nix** → defines inputs and orchestrates the build
2. **configuration.nix** → system-level config (services, boot, networking)
3. **home.nix** → user home directory setup (programs, shell aliases)
4. Imports **hardware-configuration.nix** (hardware scan)
5. Includes host-specific modules (evil-helix.nix, gtk.nix)
6. Passes inputs through `specialArgs` to modules

## Key Conventions

### Hostname Substitution
The flake uses template variables like `${config.networking.hostName}` in configuration. The actual hostname is defined in `configuration.nix` (`networking.hostName = "PD-BRFMF72";`).

### State Version
Each host has a `home.stateVersion` in home.nix (e.g., "25.11"). This prevents unwanted config resets when NixOS versions change. **Do NOT manually change this** unless migrating to a new NixOS release.

### System Packages vs User Packages
- **System-wide packages**: Add to `environment.systemPackages` in configuration.nix
- **User-specific packages**: Import modules in home.nix or add to home-manager config
- **Flatpak applications**: Use `services.flatpak.packages` array or install manually

### Modular Config Structure
Each .nix file in a host directory is usually imported in flake.nix or home.nix:
- home.nix imports: `./evil-helix.nix`, `./gtk.nix`
- flake.nix modules: `./configuration.nix`, `./host-apps.nix`, home-manager module
- This modular approach keeps configs organized and maintainable

### Environment Variables and Aliases
System-level shell aliases are defined in `configuration.nix` under `environment.shellAliases`. Example:
```nix
environment.shellAliases = {
  fr = "nh os switch ...";  # Rebuild system
  fu = "nh os switch ... --update";  # Rebuild and update
  v = "nvim";  # Quick vim
};
```

### Service Management
Services are enabled/configured in the `services.*` section of configuration.nix:
```nix
services.tailscale.enable = true;
services.expressvpn.enable = true;
```

Services run under systemd; check status/logs with:
```bash
systemctl status service-name
journalctl -u service-name
```

### Flake Inputs Management
When adding new inputs:
1. Add to `inputs` section in flake.nix
2. Add to function parameters in `outputs` (if needed)
3. Pass through `specialArgs` or direct module parameters
4. Run `nix flake update` to lock versions in flake.lock

### Theme and Color Configuration
Uses **Catppuccin** theme library (enabled in home.nix):
```nix
catppuccin = {
  enable = true;
  flavor = "mocha";
  accent = "green";
};
```
Catppuccin modules are available for various applications (nvim, zed, thunderbird, etc.).

## Important Notes

- **hardware-configuration.nix is auto-generated**: Regenerate with `sudo nixos-generate-config` if hardware changes; do not edit manually
- **flake.lock must be committed**: Contains exact input versions; `flake.lock.good` appears to be a backup
- **Multiple hosts in one repo**: Each PD-* directory is a complete host; the root flake.nix defines all outputs
- **NixOS version varies**: Check `system.stateVersion` per host; can be different across hosts
- **Flakes are experimental features**: Repo assumes flakes and nix-command are enabled globally
- **Weekly garbage collection**: Configured to run automatically; old generations auto-cleaned

## Common Edits

### Adding a system-wide package
Edit the host's **configuration.nix**:
```nix
environment.systemPackages = with pkgs; [
  # existing packages...
  new-package-name
];
```
Then run: `sudo nixos-rebuild switch --flake .#HOSTNAME`

### Enabling a service
Edit **configuration.nix**, add to `services` section:
```nix
services.new-service = {
  enable = true;
  # service-specific options...
};
```

### Adding a user program
Edit the host's **home.nix**, add to `programs`:
```nix
programs.git = {
  enable = true;
  # git-specific options...
};
```

### Updating all inputs
```bash
nix flake update
sudo nixos-rebuild switch --flake .#HOSTNAME
```

## Troubleshooting References

Refer to **WARP.md** in the host directory for comprehensive troubleshooting guides covering:
- Build failures (syntax checking, cache clearing)
- Service issues (status/log commands)
- Flatpak problems
- Generation rollback
