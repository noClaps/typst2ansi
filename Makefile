build:
	@LLVM="$$(brew --prefix llvm)"; \
	CC_wasm32_unknown_unknown="$${LLVM}/bin/clang" \
	AR_wasm32_unknown_unknown="$${LLVM}/bin/llvm-ar" \
	RANLIB_wasm32_unknown_unknown="$${LLVM}/bin/llvm-ranlib" \
	ARFLAGS_wasm32_unknown_unknown="--format=gnu" \
	CC_ENABLE_DEBUG_OUTPUT=1 \
	cargo build --target wasm32-unknown-unknown --release
	@wasm-bindgen target/wasm32-unknown-unknown/release/typst2ansi.wasm --out-dir web/typst2ansi --target web --no-typescript
