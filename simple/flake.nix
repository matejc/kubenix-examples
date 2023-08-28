{
  inputs = {
    kubenix.url = "github:hall/kubenix";
  };
  outputs = { kubenix, ... }:
  let
    system = "x86_64-linux";
    result = kubenix.evalModules.${system} {
      module = import ./module.nix;
    };
  in {
    packages.${system} = {
      default = result.config.kubernetes.result;
    };
  };
}
