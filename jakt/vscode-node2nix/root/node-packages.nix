# This file has been generated by node2nix 1.11.1. Do not edit!

{ pkgs, nodeEnv, fetchurl, fetchgit, nix-gitignore, stdenv, lib, globalBuildInputs ? [ ] }:

let
  sources = {
    "@types/vscode-1.88.0" = {
      name = "_at_types_slash_vscode";
      packageName = "@types/vscode";
      version = "1.88.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/@types/vscode/-/vscode-1.88.0.tgz";
        sha512 = "rWY+Bs6j/f1lvr8jqZTyp5arRMfovdxolcqGi+//+cPDOh8SBvzXH90e7BiSXct5HJ9HGW6jATchbRTpTJpEkw==";
      };
    };
    "balanced-match-1.0.2" = {
      name = "balanced-match";
      packageName = "balanced-match";
      version = "1.0.2";
      src = fetchurl {
        url = "https://registry.npmjs.org/balanced-match/-/balanced-match-1.0.2.tgz";
        sha512 = "3oSeUO0TMV67hN1AmbXsK4yaqU7tjiHlbxRDZOpH0KW9+CeX4bRAaX0Anxt0tx2MrpRpWwQaPwIlISEJhYU5Pw==";
      };
    };
    "brace-expansion-2.0.1" = {
      name = "brace-expansion";
      packageName = "brace-expansion";
      version = "2.0.1";
      src = fetchurl {
        url = "https://registry.npmjs.org/brace-expansion/-/brace-expansion-2.0.1.tgz";
        sha512 = "XnAIvQ8eM+kC6aULx6wuQiwVsnzsi9d3WxzV3FpWTGA19F621kwdbsAcFKXgKUHZWsy+mY6iL1sHTxWEFCytDA==";
      };
    };
    jakt-lsp-server-server = {
      name = "jakt-lsp-server";
      packageName = "jakt-lsp-server";
      version = "1.0.0";
      src = (pkgs.callPackage ../patched-src.nix { }) + /server;
    };
    "lru-cache-6.0.0" = {
      name = "lru-cache";
      packageName = "lru-cache";
      version = "6.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/lru-cache/-/lru-cache-6.0.0.tgz";
        sha512 = "Jo6dJ04CmSjuznwJSS3pUeWmd/H0ffTlkXXgwZi+eq1UCmqQwCh+eLsYOYCwY991i2Fah4h1BEMCx4qThGbsiA==";
      };
    };
    lsp-sample-client-client = {
      name = "lsp-sample-client";
      packageName = "lsp-sample-client";
      version = "0.0.1";
      src = (pkgs.callPackage ../patched-src.nix { }) + /client;
    };
    "minimatch-5.1.6" = {
      name = "minimatch";
      packageName = "minimatch";
      version = "5.1.6";
      src = fetchurl {
        url = "https://registry.npmjs.org/minimatch/-/minimatch-5.1.6.tgz";
        sha512 = "lKwV/1brpG6mBUFHtb7NUmtABCb2WZZmm2wNiOA5hAb8VdCS4B3dtMWyvcoViccwAW/COERjXLt0zP1zXUN26g==";
      };
    };
    "semver-7.6.0" = {
      name = "semver";
      packageName = "semver";
      version = "7.6.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/semver/-/semver-7.6.0.tgz";
        sha512 = "EnwXhrlwXMk9gKu5/flx5sv/an57AkRplG3hTK68W7FRDN+k+OWBj65M7719OkA82XLBxrcX0KSHj+X5COhOVg==";
      };
    };
    "tmp-0.2.3" = {
      name = "tmp";
      packageName = "tmp";
      version = "0.2.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/tmp/-/tmp-0.2.3.tgz";
        sha512 = "nZD7m9iCPC5g0pYmcaxogYKggSfLsdxl8of3Q/oIbqCqLLIO9IAF0GWjX1z9NZRHPiXv8Wex4yDCaZsgEw0Y8w==";
      };
    };
    "vscode-jsonrpc-8.1.0" = {
      name = "vscode-jsonrpc";
      packageName = "vscode-jsonrpc";
      version = "8.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-jsonrpc/-/vscode-jsonrpc-8.1.0.tgz";
        sha512 = "6TDy/abTQk+zDGYazgbIPc+4JoXdwC8NHU9Pbn4UJP1fehUyZmM4RHp5IthX7A6L5KS30PRui+j+tbbMMMafdw==";
      };
    };
    "vscode-languageclient-8.1.0" = {
      name = "vscode-languageclient";
      packageName = "vscode-languageclient";
      version = "8.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageclient/-/vscode-languageclient-8.1.0.tgz";
        sha512 = "GL4QdbYUF/XxQlAsvYWZRV3V34kOkpRlvV60/72ghHfsYFnS/v2MANZ9P6sHmxFcZKOse8O+L9G7Czg0NUWing==";
      };
    };
    "vscode-languageserver-8.1.0" = {
      name = "vscode-languageserver";
      packageName = "vscode-languageserver";
      version = "8.1.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver/-/vscode-languageserver-8.1.0.tgz";
        sha512 = "eUt8f1z2N2IEUDBsKaNapkz7jl5QpskN2Y0G01T/ItMxBxw1fJwvtySGB9QMecatne8jFIWJGWI61dWjyTLQsw==";
      };
    };
    "vscode-languageserver-protocol-3.17.3" = {
      name = "vscode-languageserver-protocol";
      packageName = "vscode-languageserver-protocol";
      version = "3.17.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-protocol/-/vscode-languageserver-protocol-3.17.3.tgz";
        sha512 = "924/h0AqsMtA5yK22GgMtCYiMdCOtWTSGgUOkgEDX+wk2b0x4sAfLiO4NxBxqbiVtz7K7/1/RgVrVI0NClZwqA==";
      };
    };
    "vscode-languageserver-textdocument-1.0.11" = {
      name = "vscode-languageserver-textdocument";
      packageName = "vscode-languageserver-textdocument";
      version = "1.0.11";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-textdocument/-/vscode-languageserver-textdocument-1.0.11.tgz";
        sha512 = "X+8T3GoiwTVlJbicx/sIAF+yuJAqz8VvwJyoMVhwEMoEKE/fkDmrqUgDMyBECcM2A2frVZIUj5HI/ErRXCfOeA==";
      };
    };
    "vscode-languageserver-types-3.17.3" = {
      name = "vscode-languageserver-types";
      packageName = "vscode-languageserver-types";
      version = "3.17.3";
      src = fetchurl {
        url = "https://registry.npmjs.org/vscode-languageserver-types/-/vscode-languageserver-types-3.17.3.tgz";
        sha512 = "SYU4z1dL0PyIMd4Vj8YOqFvHu7Hz/enbWtpfnVbJHU4Nd1YNYx8u0ennumc6h48GQNeOLxmwySmnADouT/AuZA==";
      };
    };
    "yallist-4.0.0" = {
      name = "yallist";
      packageName = "yallist";
      version = "4.0.0";
      src = fetchurl {
        url = "https://registry.npmjs.org/yallist/-/yallist-4.0.0.tgz";
        sha512 = "3wdGidZyq5PB084XLES5TpOSRA3wjXAlIWMhum2kRcv/41Sn2emQ0dycQW4uZXLejwKvg6EsvbdlVL+FYEct7A==";
      };
    };
  };
  args = {
    name = "jakt";
    packageName = "jakt";
    version = "0.0.3";
    src = (pkgs.callPackage ../patched-src.nix { });
    dependencies = [
      sources."@types/vscode-1.88.0"
      sources."balanced-match-1.0.2"
      sources."brace-expansion-2.0.1"
      sources."jakt-lsp-server-server"
      sources."lru-cache-6.0.0"
      sources."lsp-sample-client-client"
      sources."minimatch-5.1.6"
      sources."semver-7.6.0"
      sources."tmp-0.2.3"
      sources."vscode-jsonrpc-8.1.0"
      sources."vscode-languageclient-8.1.0"
      sources."vscode-languageserver-8.1.0"
      sources."vscode-languageserver-protocol-3.17.3"
      sources."vscode-languageserver-textdocument-1.0.11"
      sources."vscode-languageserver-types-3.17.3"
      sources."yallist-4.0.0"
    ];
    buildInputs = globalBuildInputs;
    meta = {
      description = "Jakt language support";
      license = "BSD";
    };
    production = true;
    bypassCache = true;
    reconstructLock = true;
  };
in
{
  args = args;
  sources = sources;
  tarball = nodeEnv.buildNodeSourceDist args;
  package = nodeEnv.buildNodePackage args;
  shell = nodeEnv.buildNodeShell args;
  nodeDependencies = nodeEnv.buildNodeDependencies (lib.overrideExisting args {
    src = stdenv.mkDerivation {
      name = args.name + "-package-json";
      src = nix-gitignore.gitignoreSourcePure [
        "*"
        "!package.json"
        "!package-lock.json"
      ]
        args.src;
      dontBuild = true;
      installPhase = "mkdir -p $out; cp -r ./* $out;";
    };
  });
}
