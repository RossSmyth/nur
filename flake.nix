{
  outputs =
    {
      self,
      nixpkgs,
    }:
    {
      overlays.default = final: _: {
        inherit (final.callPackage ./. { }) ;
      };
    };
}
