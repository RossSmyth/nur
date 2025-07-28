#!/usr/bin/env nix-shell
#! nix-shell -i nu -p nushell

def main [] {
  http get "https://aka.ms/vs/17/release/channel"
  | decode
  | from json
  | to json o> ./msvc-sdk/manifest.json
}
