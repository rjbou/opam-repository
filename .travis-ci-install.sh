wget https://raw.githubusercontent.com/rjbou/ocaml-ci-scripts/inst/.travis-ocaml.sh

export OPAM_INIT=false
bash -ex .travis-ocaml.sh
