# typst2ansi

A website used to convert Typst input into syntax-highlighted ANSI output for pasting in Discord messages.

It uses [Tree-sitter](https://tree-sitter.github.io) for syntax highlighting and a vendored copy of [uben0's tree-sitter-typst](https://github.com/uben0/tree-sitter-typst) grammar with some modifications.

The vendored grammar is still under the original [MIT license](./vendor/tree-sitter-typst/LICENSE), while the rest of the code is under the [0BSD license](./LICENSE).

## Build instructions

You'll need [Rust](https://rust-lang.org), [LLVM](https://llvm.org) and the [`wasm-bindgen` CLI tool](https://github.com/wasm-bindgen/wasm-bindgen).

Clone the repository.

```sh
git clone https://github.com/noClaps/typst2ansi.git
cd typst2ansi
```

Run the build script for your system

```sh
make build-mac   # assumes LLVM was installed with `brew install llvm`
make build-linux
```

The `web/` directory will then have all of the required files for the site to work.

## AI Disclosure

AI was used to help with debugging some issues I was having with the Tree-sitter queries and the CI workflow, and to write the build scripts in the Makefile. Aside from that and the vendored grammar, all of the code was written by me.
