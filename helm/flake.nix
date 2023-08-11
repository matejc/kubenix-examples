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
    pkgs = import nixpkgs { };
  in {
    packages.${system}.default = (kubenix.evalModules.${system} {
      module = import ./module.nix;
      specialArgs = { inherit pkgs; };
    }).config.kubernetes.result;
  };
}
