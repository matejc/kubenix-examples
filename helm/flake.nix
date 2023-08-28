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
    pkgs = import nixpkgs { inherit system; };
    result = kubenix.evalModules.${system} {
      module = import ./module.nix;
      specialArgs = { inherit pkgs; };
    };
  in {
    packages.${system}.default = result.config.kubernetes.result;
  };
}
