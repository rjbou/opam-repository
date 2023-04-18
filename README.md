# opam-repository-mingw

[OCaml for Windows](https://fdopen.github.io/opam-repository-mingw/) was a fork of OCaml providing support for the mingw-w64 and MSVC ports of OCaml maintained by [@fdopen](https://github.com/fdopen).

Its deprecation was announced in [August 2021](https://fdopen.github.io/opam-repository-mingw/2021/02/26/repo-discontinued/) and it has received no updates since November 2022 in [696c4b2](https://github.com/fdopen/opam-repository-mingw/commit/696c4b27488b4b0d3ec3929dbe65565cb91764a1).

OCaml's [setup-ocaml](https://github.com/ocaml/setup-ocaml) GitHub Action as well as other CI systems were still using [fdopen/opam-repository-mingw](https://github.com/fdopen/opam-repository-mingw) with [ocaml/opam-repository](https://github.com/ocaml/opam-repository) added to switch selections to provide newer packages. However, this was problematic when new releases require the constraints of existing packages to be updated.

## Updates

This repository adds packages for OCaml 4.14.1 (released 19 Dec, 2022) and contains updates to _existing_ packages only to allow upstream opam-repository to be safely used, as constraints updated to deal with _new_ releases of packages are copied back to this repository.

All new releases should be made to opam-repository only. This repository will only be periodically updated with constraint changes made in opam-repository. Issues and pull requests towards this goal are warmly welcomed!

It is possible to use this repository with opam-repository. It's necessary to _add_ opam-repository to the repositories selections for the switches. It's important that opam-repository is at a _lower priority_ than opam-repository-mingw for existing packages, so it's better to use these lines in your `ocaml/setup-ocaml@v2` step than to issue `opam repo add` later:

```
uses: ocaml/setup-ocaml@v2
with:
  opam-repositories: |
    opam-repository-mingw: https://github.com/ocaml-opam/opam-repository-mingw.git#sunset
    default: https://github.com/ocaml/opam-repository.git
```

This is not the default in setup-ocaml at present because newer versions of packages may not contain required patches.

## What do I do when things are broken?

Please open an issue in the [issue tracker](https://github.com/ocaml-opam/opam-repository-mingw/issues)!

If a version of a package isn't building, there are three possible remedies:

- Previous versions of the package may have carried non-upstreamed patches in opam-repository-mingw. opam-repository's policy is not to carry such patches. In this case, the package actually doesn't work on Windows.
  - opam-repository should be updated to have `os != "win32"` added to the `available` field for the package
  - An issue on the package's upstream repo should be opened highlighting the need to upstream patches (or even a pull request with them!)
  - The patches in opam-repository-mingw make changes which may not necessarily be accepted/acceptable upstream in their current form, so the issue may be a better starting point than simply taking a patch and opening a pull request for it (for example, the `utop` package contains patches which may require further work and review)
- The package relies on environment changes in "OCaml for Windows". For example, the Zarith package works in "OCaml for Windows" because the compiler packages unconditionally set the `CC` environment variable. This change is both not particularly desirable change to upstream (it is _very_ confusing, for example, when working on the compiler itself) and also extremely difficult to upstream, so the fix here is instead to change the package's availability with `(os != "win32" | os-distribution = "cygwinports")` and constrain away OCaml 5 on Windows (`"ocaml" {< "5.0" | os != "win32"}`)
- Package constraints on _existing packages_ need updating in ocaml-opam/opam-repository-mingw. For example, the release of ppxlib 0.29 required some existing packages to have upperbounds added.

## Sunset

[opam 2.2](https://github.com/ocaml/opam) offers full support for native Windows development. As part of the development of opam 2.2, opam-repository's compiler packages will be updated to enable native Windows opam switches without needing this repository.

Packages should then be fixed upstream in the usual way with new releases providing Windows support, with the gradual aim of allowing all Windows users to use ocaml/opam-repository only and cease using this repository completely.
