{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    kubenix = {
      url = "github:hall/kubenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, kubenix, ... }:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    packages.${system} = (kubenix.evalModules.${system} {
      module = import ./module.nix;
      specialArgs = { inherit pkgs; };
    }).config;
  };
}
