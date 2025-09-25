# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

This is a NixOS system configuration using Nix flakes for the hostname `PD-G4BK722`. The configuration is specifically set up to run the COSMIC desktop environment with various productivity and development tools.

## Architecture and Structure

### Core Configuration Files
- **`flake.nix`**: Main flake definition with inputs and outputs, defines the NixOS system configuration
- **`configuration.nix`**: Primary system configuration including services, packages, and hardware settings
- **`hardware-configuration.nix`**: Hardware-specific configuration (auto-generated, should not be manually edited)
- **`host-apps.nix`**: Additional host-specific application packages (currently empty)
- **`default.nix`**: Convenience file that imports other configuration modules
- **`flake.lock`**: Locked dependency versions for reproducible builds
- **`node-packages.json`**: Node.js packages to be managed by Nix (currently only includes CKEditor5)
- **`HubApps`**: Microsoft Edge Hub Apps configuration (JSON format)

### Key Flake Inputs
- **nixpkgs**: Main NixOS package repository (nixos-unstable channel)
- **nixvim**: Custom Neovim configuration from dc-tec
- **zen-browser**: Alternative browser from MarceColl
- **nix-flatpak**: Flatpak integration for NixOS
- **cosmic-manager**: COSMIC desktop environment manager
- **home-manager**: User environment management

### System Features
- **Desktop Environment**: COSMIC desktop with cosmic-greeter
- **Applications**: Includes development tools (VSCode, GitKraken, Helix), productivity apps (Firefox, LibreOffice), and system utilities
- **Services**: Tailscale, ExpressVPN, Flatpak, TeamViewer
- **Package Management**: Hybrid approach using Nix packages and Flatpak

## Common Development Commands

### Building and Applying Configuration
```bash
# Build the configuration (dry-run to check for errors)
sudo nixos-rebuild dry-build --flake .#PD-G4BK722

# Apply the configuration
sudo nixos-rebuild switch --flake .#PD-G4BK722

# Build and switch in one command
sudo nixos-rebuild switch --flake .

# Update flake inputs before rebuilding
nix flake update && sudo nixos-rebuild switch --flake .
```

### Testing Configuration Changes
```bash
# Test configuration without making it the default boot option
sudo nixos-rebuild test --flake .#PD-G4BK722

# Build configuration in a VM for testing
nixos-rebuild build-vm --flake .#PD-G4BK722
```

### Flake Management
```bash
# Update all flake inputs
nix flake update

# Update specific input
nix flake update zen-browser

# Check flake configuration
nix flake check

# Show flake information
nix flake show
```

### System Information and Cleanup
```bash
# List system generations
sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# Clean up old generations (automatic cleanup is configured weekly)
sudo nix-collect-garbage --delete-older-than 7d

# Force garbage collection
sudo nix-collect-garbage -d
```

### Node Package Management
```bash
# Update Node.js packages (when node-packages.json is modified)
node2nix -i node-packages.json -o node-packages.nix -c node-env.nix

# This regenerates the Nix expressions for Node.js packages
```

## Configuration Patterns

### Adding New System Packages
Add packages to the `environment.systemPackages` list in `configuration.nix`:
```nix
environment.systemPackages = with pkgs; [
  # existing packages...
  your-new-package
];
```

### Adding New Services
Enable services in the `services` section of `configuration.nix`:
```nix
services.your-service = {
  enable = true;
  # additional configuration
};
```

### Adding Flake Inputs
1. Add the input to `flake.nix` inputs section
2. Pass it through to modules via `specialArgs` or direct module parameters
3. Update flake lock: `nix flake update`

### Managing User Applications
- System-wide applications: Add to `environment.systemPackages`
- User-specific applications: Consider using home-manager (input is available)
- Flatpak applications: Add to `services.flatpak.packages` array or install manually

## Important Notes

- The system uses NixOS 24.05 as the base version (see `system.stateVersion`)
- COSMIC desktop environment is enabled with cosmic-greeter display manager
- Flakes and nix-command experimental features are enabled
- Automatic store optimization and weekly garbage collection are configured
- The hostname is `PD-G4BK722` - update this in flake.nix if deploying elsewhere
- Hardware configuration should not be manually edited - regenerate with `nixos-generate-config`

## Troubleshooting

### Build Failures
- Check syntax with `nix flake check`
- Verify all inputs are accessible
- Clear Nix cache if needed: `sudo nix-store --verify --repair`

### Service Issues
- Check service status: `systemctl status service-name`
- View service logs: `journalctl -u service-name`
- Rebuild and restart services: `sudo nixos-rebuild switch --flake .`

### Flatpak Issues
- Update Flatpak remotes: `flatpak update`
- Check Flatpak service: `systemctl --user status flatpak-repo`