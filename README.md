# Pkgs
> Nixpkgs personalized

This can be used as a Git submodule to pin nixpkgs to a particular release and add custom packages. It also allows to easily create Docker and Singularity containers.

## Organization
This repo tries to be minimal and thus does not include packages definitions from [NixOS/nixpkgs](https://github.com/NixOS/nixpkgs). Yet it follows the same folder structure so that customs packages added here can easily be copy pasted to a `NixOS/nixpkgs` fork to be included in the official nixpkgs release via pull requests. Custom packages added this way to the official Nix will be maintained there and removed from this repo.

## Usage
Edit `shell.nix` to adjust the name and version of your project to anything you want (optional).

### Add dependencies
You can put any dependencies in the property `buildInputs` of the `shell.nix` file.

### Change packages source
Edit `nixsrc.json` and change the property `origin.rev` (revision) to any Git commit hash of [NixOS/nixpkgs](https://github.com/NixOS/nixpkgs) that you would like to use. The `version` property is a meaningful human friendly string that represents the current source and is used for things like tagging Docker images. It can be anything you want, such as "`17.09-beta`" (a Nix release tag), "`my-private-fork`" or "`lab-name`". If you want you can also change the `owner` and `repo` to a GitHub fork of `NixOS/nixpkgs`. You can figure out the needed `sha256` property by trying to run any command after the change and looking at the output error where it says `output path ‘/nix/store/X’ has r:sha256 hash ‘Y’ when ‘Z’ was expected` and replacing the `sha256` property with the hash `‘Z’`.


### Commands
As script is provided to add easy to use commands to your shell. Just `source ./nix` in the root of this repository and you will be able to use the commands below:

#### Shell
>`nix shell`

Goes into a shell with the dependencies specified in `shell.nix`.  
Similar to doing: `nix-shell` in the repository root.

#### Install
> `nix install package-name`

Installs any package from official Nix or custom defined in this repo.  
Similar to doing: `nix-env -f ./default.nix -iA package-name`

#### Build
> `nix build package-name-or-shell`

Builds any packages from official Nix or custom defined in this repo. Can also build the `nix shell` environment when called with `shell` instead of the package name. The result will be stored in `/nix/store` and linked locally at `result`.  
Similar to doing: `nix-build . -A package-name-or-shell`

#### Docker
> `nix docker package-name-or-shell`

Same as `nix build` but `result` will point to a Docker compatible tarball that will automatically be loaded into Docker as the root base system and run.  
Similar to doing:
```bash
nix-build . -A dockerTar --argstr pkg package-name-or-shell
docker load < result
docker run -ti --rm -v $(pwd):/data package-name-or-shell:pkg-version_nix-version /bin/sh
```

#### Singularity
> `nix singularity package-name-or-shell`

Similar to `nix docker` but instead of running the Docker image loaded from the `result` Docker tarball, it will export it back into another tarball that can be loaded by Singularity with:  
`singularity exec package-name-or-shell_pkg-version_nix-version.tar.gz`  
Similar to doing:
```bash
nix-build . -A dockerTar --argstr pkg package-name-or-shell
docker load < result
docker run package-name-or-shell:pkg-version_nix-version /bin/sh
docker export package-name-or-shell:pkg-version_nix-version | \
  gzip > package-name-or-shell_pkg-version_nix-version.tar.gz
```

### Add new packages
Put a `default.nix` derivation for your package in the appropriate folder structure inside `pkgs` (have a look at how packages are organized at [NixOS/nixpkgs](https://github.com/NixOS/nixpkgs)). Then add a `callPackage` definition inside the property `customPkgs` of `pkgs/top-level/all-packages.nix`.