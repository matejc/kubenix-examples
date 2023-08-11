{
  inputs = {
    kubenix.url = "github:hall/kubenix";
  };
  outputs = { kubenix, ... }:
  let
    system = "x86_64-linux";
  in {
    packages.${system}.default = (kubenix.evalModules.${system} {
      module = import ./module.nix;
    }).config.kubernetes.result;
  };
}
