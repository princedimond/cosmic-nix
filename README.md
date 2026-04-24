# 🌌 Cosmic-Nix: Elegant COSMIC Desktop NixOS Configurations

> **Declarative NixOS configurations optimized for the COSMIC Desktop Environment**  
> A streamlined, reproducible system setup leveraging Nix Flakes for multiple machines running the beautiful COSMIC desktop.

---

## 🎯 At a Glance

| Property | Details |
|----------|---------|
| **Language** | 100% Nix |
| **License** | GPL-3.0 |
| **Desktop** | 🌌 COSMIC (Pop!_OS) |
| **Deployments** | 3 active configurations |
| **Last Updated** | 2026-04-24 |
| **Status** | ✅ Active Development |

---

## 📑 Table of Contents

- [✨ Overview](#-overview)
- [🏗️ Repository Structure](#️-repository-structure)
- [🚀 Quick Start Guide](#-quick-start-guide)
- [📦 Deployment Configurations](#-deployment-configurations)
- [🔧 System Configuration](#-system-configuration)
- [🎨 Desktop & Theming](#-desktop--theming)
- [📦 Package Management](#-package-management)
- [🛠️ Common Operations](#️-common-operations)
- [🐛 Troubleshooting](#-troubleshooting)
- [📚 Advanced Configuration](#-advanced-configuration)

---

## ✨ Overview

**cosmic-nix** is a curated collection of declarative NixOS configurations designed specifically for the [COSMIC Desktop Environment](https://github.com/pop-os/cosmic). This project emphasizes:

- ✅ **COSMIC-First Design**: Optimized for the COSMIC desktop, Pop!_OS's modern Wayland environment
- ✅ **Reproducibility**: Identical system states across multiple machines via Nix Flakes
- ✅ **Modularity**: Clean separation of hardware, system, and user configurations
- ✅ **Minimalism**: Focused on essentials without unnecessary bloat
- ✅ **Home Manager Integration**: User-level dotfile and environment management
- ✅ **Flatpak Support**: Seamless application distribution via Flatpak
- ✅ **Catppuccin Theming**: Beautiful, consistent color schemes across all applications

---

## 🏗️ Repository Structure

```
cosmic-nix/
├── README.md                          # This file
├── LICENSE.md                         # GPL-3.0 License
│
├── PD-BRFMF72/                        # Deployment #1 (Primary)
│   ├── flake.nix                      # 🔑 Main entry point - defines inputs & outputs
│   ├── flake.lock                     # Locked dependency versions (reproducibility)
│   ├── configuration.nix              # System-level configuration
│   ├── hardware-configuration.nix     # Hardware-specific settings (auto-generated)
│   ├── home.nix                       # User environment (Home Manager)
│   ├── host-apps.nix                  # Host-specific applications
│   ├── default.nix                    # Convenience wrapper
│   ├── evil-helix.nix                 # Helix text editor configuration
│   ├── gtk.nix                        # GTK theme settings
│   ├── HubApps                        # Microsoft Edge Hub Apps config
│   ├── WARP.md                        # Development guidelines
│   └── flake.lock.good                # Backup of working flake lock
│
├── PD-G4BK722/                        # Deployment #2 (Experimental)
│   ├── [similar structure to PD-BRFMF72]
│   ├── node-packages.json             # Node.js dependencies
│   ├── node-packages.nix              # Generated Nix expressions for Node packages
│   ├── node-env.nix                   # Node environment setup
│   ├── default.nix.node2nix           # Node2nix configuration
│   ├── x11compat.configuration.nix    # X11 compatibility fallback
│   └── sh.nix                         # Shell environment
│
├── PD-JMP7YY2/                        # Deployment #3 (Testing)
│   ├── [similar base structure]
│   ├── crd.nix                        # Chrome Remote Desktop configuration
│   ├── configuration.JMP7YY2          # Alternative configuration variant
│   ├── chrome-remote-desktop.nix.tempmal # CRD template
│   ├── flake.nix.bkp                  # Backup configuration
│   ├── hardware-configuration.G4BK722 # Alternative hardware config
│   └── error.log                      # Error tracking
│
└── .github/                           # GitHub integration
    └── [workflows, templates, etc.]
```

### Key File Descriptions

#### **`flake.nix`** 🔑 (Flake Configuration)
The entry point for the entire system. Defines:
- **Inputs**: Dependencies (nixpkgs, home-manager, cosmic-manager, etc.)
- **Outputs**: System configuration declaration
- **Hostname**: Maps to NixOS system configuration
- **Module composition**: Combines hardware, configuration, and home settings

```nix
# Example structure:
inputs = {
  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  cosmic-manager = { /* COSMIC theming */ };
  home-manager = { /* User config */ };
  zen-browser = { /* Alternative browser */ };
};

outputs = { nixpkgs, cosmic-manager, home-manager, ... }: {
  nixosConfigurations.PD-BRFMF72 = nixpkgs.lib.nixosSystem { /* ... */ };
};
```

#### **`configuration.nix`** (System Configuration)
Main system-level settings including:
- Boot and kernel configuration
- Hardware and device setup
- Services (printing, VPN, remote access, etc.)
- System packages and environment
- Keyboard layout and locale
- Desktop environment (COSMIC) setup

#### **`home.nix`** (User Configuration)
User environment managed by Home Manager:
- User packages and applications
- Git configuration
- Catppuccin theming preferences
- Program configurations (btop, lazygit, yazi, etc.)

#### **`hardware-configuration.nix`** ⚠️ (Auto-Generated)
Do NOT manually edit. Regenerate with:
```bash
sudo nixos-generate-config --root /mnt
```

---

## 🚀 Quick Start Guide

### Prerequisites

- **NixOS 24.05+** or nixos-unstable installed
- **Git** for cloning
- **Nix Flakes** enabled (modern Nix setup)
- **Terminal** with sudo access

### Enable Nix Flakes

If you haven't already enabled Nix Flakes, add to `/etc/nixos/configuration.nix`:

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

Then rebuild:
```bash
sudo nixos-rebuild switch
```

### Clone & Deploy

```bash
# 1. Clone the repository
git clone https://github.com/princedimond/cosmic-nix.git
cd cosmic-nix

# 2. Navigate to desired deployment
cd PD-BRFMF72

# 3. Verify flake is valid
nix flake check

# 4. Build and switch (dry-run first to check)
sudo nixos-rebuild dry-build --flake .#PD-BRFMF72

# 5. Apply configuration
sudo nixos-rebuild switch --flake .#PD-BRFMF72

# 6. Verify installation
echo "System switched successfully!"
nixos-rebuild list-generations
```

---

## 📦 Deployment Configurations

### Overview Table

| Hostname | Channel | Status | Focus | Hardware |
|----------|---------|--------|-------|----------|
| **PD-BRFMF72** | nixos-unstable | ✅ Active | Primary workstation | Desktop |
| **PD-G4BK722** | nixos-unstable | ✅ Active | Development/Testing | Laptop |
| **PD-JMP7YY2** | nixos-unstable | ✅ Testing | Remote access capable | Server |

### PD-BRFMF72 (Primary Workstation)

**Focus**: Full-featured desktop workstation with development tools

**Highlights**:
- ✅ COSMIC Desktop with cosmic-greeter display manager
- ✅ Development tools: VSCode, GitKraken, Helix, Lazygit
- ✅ Productivity: LibreOffice, Calibre, OnlyOffice
- ✅ Creative: Orca Slicer, Affine, Lunacy, AppFlowy
- ✅ Multimedia: VLC, Deluge torrent client
- ✅ Services: Tailscale, ExpressVPN, TeamViewer
- ✅ Kernel: Linux Zen (optimized)
- ✅ Flatpak: Microsoft Edge, OpenBubbles, Simplenote, Muon

**Special Features**:
```nix
# Catppuccin theming (mocha + green accent)
catppuccin = {
  flavor = "mocha";
  accent = "green";
  cursors.enable = true;
  zed.enable = true;
  thunderbird.enable = true;
  nvim.enable = true;
};
```

### PD-G4BK722 (Development/Testing)

**Focus**: Lightweight development machine with Node.js support

**Highlights**:
- ✅ Minimal base system
- ✅ Node.js package management via node2nix
- ✅ X11 compatibility fallback
- ✅ Shell environment customization
- ✅ Extended hardware configuration

**Unique Features**:
- `node-packages.json` for npm dependency management
- `x11compat.configuration.nix` for X11/Wayland switching

### PD-JMP7YY2 (Remote Access/Server)

**Focus**: Server-focused with remote access capabilities

**Highlights**:
- ✅ Chrome Remote Desktop support
- ✅ Alternative configuration variants
- ✅ Error tracking and logging
- ✅ Multiple hardware configurations
- ✅ Testing bed for new features

---

## 🔧 System Configuration

### Desktop Environment (COSMIC)

The COSMIC desktop is elegantly configured in `configuration.nix`:

```nix
# Enable COSMIC Desktop
services.desktopManager.cosmic.enable = true;
services.displayManager.cosmic-greeter.enable = true;

# Portal configuration for applications
xdg.portal = {
  enable = true;
  config.common = {
    default = ["cosmic" "gtk"];
    "org.freedesktop.impl.portal.RemoteDesktop" = "wlr";
    "org.freedesktop.impl.portal.ScreenCast" = "wlr";
  };
  extraPortals = [
    pkgs.xdg-desktop-portal-gtk
    pkgs.xdg-desktop-portal-cosmic
    pkgs.xdg-desktop-portal-wlr
  ];
};
```

### Audio & Video (PipeWire)

Professional audio setup with PipeWire (replacing PulseAudio):

```nix
services.pipewire = {
  enable = true;
  alsa.support32Bit = true;
  alsa.enable = true;
  pulse.enable = true;
  wireplumber.enable = true;
};
```

### Keyboard Configuration

```nix
services.xserver.xkb = {
  layout = "us";           # Change to "de", "fr", etc.
  variant = "";            # Leave empty for standard layout
};

# Or enable multiple layouts with Alt+Shift switching
# keyboard.options = ["grp:alt_shift_toggle"];
# keyboard.additionalLayouts = ["de"];
```

### Locale & Timezone

```nix
time.timeZone = "America/Chicago";  # Adjust to your timezone
i18n.defaultLocale = "en_US.UTF-8";

i18n.extraLocaleSettings = {
  LC_ADDRESS = "en_US.UTF-8";
  LC_IDENTIFICATION = "en_US.UTF-8";
  # ... (all locale categories set to en_US.UTF-8)
};
```

### Boot Configuration

```nix
# EFI Boot with systemd-boot
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;

# Linux Zen kernel (optimized for desktop)
boot.kernelPackages = pkgs.linuxPackages_zen;

# VM memory settings for games and virtual machines
boot.kernel.sysctl = {
  "vm.max_map_count" = 2147483642;  # Needed for Steam games
};
```

---

## 🎨 Desktop & Theming

### Catppuccin Theme Integration

The **Catppuccin** theme system provides beautiful, consistent coloring across all applications:

```nix
# In home.nix
catppuccin = {
  enable = true;
  flavor = "mocha";        # Options: latte, frappe, macchiato, mocha
  accent = "green";        # Options: rosewater, flamingo, pink, mauve, red, maroon, 
                           # peach, yellow, green, teal, sky, sapphire, blue, lavender
  cursors.enable = true;
  zed.enable = true;
  thunderbird.enable = true;
  nvim.enable = true;
};

# Apply to programs with Catppuccin support
programs = {
  btop.enable = true;      # System monitor
  lazygit.enable = true;   # Git UI
  yazi.enable = true;      # File manager
  television.enable = true; # Command palette
};
```

### GTK Theme Configuration

Edit `gtk.nix` to customize GTK application appearance:

```nix
# gtk.nix - GTK theme customization
# Define your GTK settings here
```

---

## 📦 Package Management

### System Packages

All system-wide packages are declared in `configuration.nix`:

**Categories**:
- **Development**: VSCode, GitKraken, nixd, node2nix, helix
- **Productivity**: LibreOffice, Calibre, OnlyOffice, Logseq, StandardNotes
- **Networking**: Tailscale, ExpressVPN, Rdesktop, WindTerm
- **Utilities**: btop, htop, glances, direnv, fastfetch, yazi
- **Media**: VLC, Deluge, Orca Slicer, Affine
- **System**: flatpak, teamviewer, keybase, warp-terminal
- **Office**: Keybase, Git tools, Thunderbird

### Adding New Packages

**Step 1**: Edit `environment.systemPackages` in `configuration.nix`:
```nix
environment.systemPackages = with pkgs; [
  # existing packages...
  your-new-package
];
```

**Step 2**: Rebuild and switch:
```bash
sudo nixos-rebuild switch --flake .
```

### Flatpak Applications

Flatpak provides sandboxed applications. Configure in `configuration.nix`:

```nix
services.flatpak = {
  enable = true;
  packages = [
    "com.microsoft.Edge"
    "app.openbubbles.OpenBubbles"
    "io.github.subhra74.Muon"
    "com.simplenote.Simplenote"
  ];
};

# Auto-install on startup
systemd.services.flatpak-repo = {
  path = [ pkgs.flatpak ];
  script = ''
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    flatpak install -y microsoft-edge
    # ... more installations
  '';
};
```

### User Packages (Home Manager)

Install packages for the current user only via `home.nix`:

```nix
home.packages = with pkgs; [
  # User-specific packages
  your-package-here
];
```

### Node.js Package Management

For PD-G4BK722 with Node support:

**1. Edit `node-packages.json`**:
```json
{
  "ckeditor5": "*"
}
```

**2. Regenerate Nix expressions**:
```bash
node2nix -i node-packages.json -o node-packages.nix -c node-env.nix
```

**3. Include in configuration**:
```nix
environment.systemPackages = [ node-packages ];
```

---

## 🛠️ Common Operations

### Building & Deploying

```bash
# Dry-run to check for errors
sudo nixos-rebuild dry-build --flake .#PD-BRFMF72

# Build without switching (creates new generation)
sudo nixos-rebuild build --flake .#PD-BRFMF72

# Test configuration (active until reboot)
sudo nixos-rebuild test --flake .#PD-BRFMF72

# Apply configuration (sets as default boot)
sudo nixos-rebuild switch --flake .#PD-BRFMF72

# Update flake inputs and switch
nix flake update && sudo nixos-rebuild switch --flake .#PD-BRFMF72
```

### Generation Management

```bash
# List all system generations
nixos-rebuild list-generations

# Boot into previous generation (select at GRUB)
# Use GRUB menu on next boot: Press 'e' to edit, navigate generations

# Delete old generations (keep only recent ones)
sudo nix-collect-garbage --delete-older-than 7d

# Force immediate garbage collection
sudo nix-collect-garbage -d

# Repair Nix store
sudo nix-store --verify --repair
```

### Flake Management

```bash
# Check flake syntax
nix flake check

# Update all inputs
nix flake update

# Update specific input
nix flake update zen-browser

# Show all flake information
nix flake show

# Lock flake to specific commit
# Edit flake.nix manually, then run:
nix flake lock
```

### Service Management

```bash
# Check service status
systemctl status service-name

# View service logs (last 50 lines)
journalctl -u service-name -n 50

# Follow logs in real-time
journalctl -u service-name -f

# Restart service
sudo systemctl restart service-name

# Rebuild and restart all services
sudo nixos-rebuild switch --flake .
```

### Shell Aliases

Pre-configured in `configuration.nix`:

```bash
# Full system rebuild and switch
fr

# Rebuild with flake update
fu

# Open Helix editor
v
```

---

## 🐛 Troubleshooting

### Issue: "Cannot find flake"

**Error**: `error: flake 'path:.' does not provide attribute 'nixosConfigurations.PD-BRFMF72'`

**Solution**:
1. Verify you're in the correct directory: `pwd`
2. Check flake.nix exists: `ls -la flake.nix`
3. Verify hostname in flake.nix matches your command
4. Validate syntax: `nix flake check`

### Issue: "Flakes not enabled"

**Error**: `experimental feature 'nix-command' is disabled`

**Solution**:
1. Edit `/etc/nixos/configuration.nix`
2. Add or update:
```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```
3. Rebuild: `sudo nixos-rebuild switch`

### Issue: "Package not found"

**Error**: `error: Package 'xyz' does not exist`

**Solution**:
1. Search available packages: `nix search nixpkgs xyz`
2. Update nixpkgs: `nix flake update nixpkgs`
3. Check package name in [Nixos.org search](https://search.nixos.org/packages)
4. Verify spelling and case sensitivity

### Issue: COSMIC Desktop not loading

**Error**: Black screen or missing desktop environment

**Solution**:
1. Verify COSMIC is enabled:
```nix
services.desktopManager.cosmic.enable = true;
services.displayManager.cosmic-greeter.enable = true;
```
2. Rebuild: `sudo nixos-rebuild switch --flake .`
3. Reboot: `sudo reboot`
4. Check logs: `journalctl -xb`

### Issue: Flatpak won't install

**Error**: Flatpak installation fails

**Solution**:
1. Check Flatpak service: `systemctl --user status flatpak-repo`
2. Update Flatpak manually: `flatpak update`
3. Add repository: `flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo`
4. Retry installation: `flatpak install app-name`

### Issue: Remote Desktop not working

**Problem**: Chrome Remote Desktop or TeamViewer not connecting

**Solution**:
1. Verify services are enabled:
```nix
services.teamviewer.enable = true;
```
2. Check service status: `systemctl status teamviewerd`
3. Look for issues in CRD config: `cat crd.nix`
4. Check firewall: `sudo ufw status`

### Issue: Low disk space

**Problem**: System nearly full, Nix store taking up space

**Solution**:
1. Immediate cleanup:
```bash
sudo nix-collect-garbage -d
sudo nix-store --gc
```
2. Find large paths:
```bash
nix-store -q --roots /nix/store/path-hash*
```
3. Delete old generations:
```bash
sudo nix-collect-garbage --delete-older-than 30d
```
4. Consider enabling automatic cleanup in configuration.nix

---

## 📚 Advanced Configuration

### Creating a New Deployment

To deploy to a new machine:

**Step 1**: Copy existing deployment
```bash
cp -r PD-BRFMF72 PD-MYHOSTNAME
cd PD-MYHOSTNAME
```

**Step 2**: Generate hardware configuration
```bash
sudo nixos-generate-config --root /mnt
# Copy the generated hardware-configuration.nix
cp /mnt/etc/nixos/hardware-configuration.nix ./
```

**Step 3**: Update flake.nix hostname
```nix
nixosConfigurations = {
  PD-MYHOSTNAME = nixpkgs.lib.nixosSystem {
    # ...
  };
};
```

**Step 4**: Update configuration.nix
```nix
networking.hostName = "PD-MYHOSTNAME";
```

**Step 5**: Deploy
```bash
sudo nixos-rebuild switch --flake .#PD-MYHOSTNAME
```

### Custom Nix Packages

Create custom packages via overlays:

**1. Create `overlays/default.nix`**:
```nix
final: prev: {
  my-custom-app = final.stdenv.mkDerivation {
    name = "my-custom-app";
    src = /path/to/source;
    buildPhase = "make";
    installPhase = "make install";
  };
}
```

**2. Import in `flake.nix`**:
```nix
nixpkgs.overlays = [ (import ./overlays) ];
```

### XDG Desktop Portal Configuration

Customize how applications handle file dialogs and permissions:

```nix
xdg.portal = {
  enable = true;
  config.common = {
    default = [ "cosmic" "gtk" ];
    "org.freedesktop.impl.portal.RemoteDesktop" = "wlr";
    "org.freedesktop.impl.portal.ScreenCast" = "wlr";
  };
  extraPortals = [ 
    pkgs.xdg-desktop-portal-gtk 
    pkgs.xdg-desktop-portal-cosmic 
  ];
};
```

### VPN Configuration

**ExpressVPN**:
```nix
services.expressvpn.enable = true;
```

**Tailscale** (recommended for teams):
```nix
services.tailscale.enable = true;

# Connect with:
# sudo tailscale up
```

### SSH Configuration

```nix
services.openssh.enable = true;

# In home.nix:
programs.ssh = {
  enable = true;
  matchBlocks = {
    "github.com" = {
      user = "princedimond";
      identityFile = "~/.ssh/id_rsa";
    };
  };
};
```

### Git Configuration

Already configured in `home.nix`:

```nix
programs.git = {
  enable = true;
  lfs.enable = true;
  settings = {
    user.name = "princedimond";
    user.email = "princedimond@gmail.com";
    credential.helper = "!${pkgs.gh}/bin/gh auth git-credential";
  };
};
```

---

## 🔗 Resources

- **Official Documentation**
  - [NixOS Manual](https://nixos.org/manual/nixos/stable/)
  - [Home Manager Manual](https://nix-community.github.io/home-manager/)
  - [Nix Flakes](https://nixos.wiki/wiki/Flakes)

- **COSMIC Desktop**
  - [COSMIC Project](https://github.com/pop-os/cosmic)
  - [COSMIC Manager](https://github.com/HeitorAugustoLN/cosmic-manager)

- **Theming & Appearance**
  - [Catppuccin](https://catppuccin.com/)
  - [Catppuccin Nix](https://github.com/catppuccin/nix)

- **Community & Support**
  - [NixOS Discourse](https://discourse.nixos.org/)
  - [NixOS Wiki](https://nixos.wiki/)
  - [NixOS Discord](https://discord.gg/RbvHtQXF2B)

---

## 📄 License

This project is licensed under the **GNU General Public License v3.0**  
See [LICENSE.md](LICENSE.md) for details.

---

## 🤝 Contributing

Contributions welcome! Please:
- Report issues via [GitHub Issues](https://github.com/princedimond/cosmic-nix/issues)
- Submit improvements via [Pull Requests](https://github.com/princedimond/cosmic-nix/pulls)
- Discuss improvements in [Discussions](https://github.com/princedimond/cosmic-nix/discussions)

---

## 📞 Support & Contact

- **Owner**: [@princedimond](https://github.com/princedimond)
- **Issues**: [Report a Problem](https://github.com/princedimond/cosmic-nix/issues)
- **Discussions**: [Start a Discussion](https://github.com/princedimond/cosmic-nix/discussions)

---

<div align="center">

### ⭐ If you find this helpful, please star the repository!

**Built with ❤️ for the COSMIC Desktop Environment**

*"Simplicity through declaration, beauty through design"*

---

**Quick Links**: [Flake Docs](https://nixos.wiki/wiki/Flakes) | [COSMIC](https://github.com/pop-os/cosmic) | [Catppuccin](https://catppuccin.com/)

*Last Updated: 2026-04-24*

</div>
