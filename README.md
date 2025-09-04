# Sandnix
Nix package and flake for the Game [Sandtrix](https://mslivo.itch.io/sandtrix) 

## Prerequisites
Download `Sandtrix_3.0_LINUX.tar.gz` from [mslivo.itch.io/sandtrix](https://mslivo.itch.io/sandtrix) and add it to the nix store: 

```bash
$ nix-store --add-fixed sha256 Sandtrix_3.0_LINUX.tar.gz
/nix/store/jrrw3872mlwagjv6axn1h5x09l37f17z-Sandtrix_3.0_LINUX.tar.gz
```

## Testing
If you don't want to permanently add sandnix to your system configuration, you can run it via `nix run`: 

```bash
$ nix run github:Luk-ESC/sandnix
``` 


## Installation
Add this flake to your inputs and install the default package. 

```nix
{
  inputs = {
    # ... other inputs ...

    sandnix = {
      url = "github:Luk-ESC/sandnix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, sandnix, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        {
          environment.systemPackages = [
              sandnix.packages.x86_64-linux.default
          ];
        }
      ];
    };
  };
}  
``` 
