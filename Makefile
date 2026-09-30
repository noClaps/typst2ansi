build-mac:
	@LLVM="$$(brew --prefix llvm)"; \
	AR_wasm32_unknown_unknown="$${LLVM}/bin/llvm-ar" \
	RANLIB_wasm32_unknown_unknown="$${LLVM}/bin/llvm-ranlib" \
	ARFLAGS_wasm32_unknown_unknown="--format=gnu" \
	CC_ENABLE_DEBUG_OUTPUT=1 \
	cargo build --target wasm32-unknown-unknown --release
	@wasm-bindgen target/wasm32-unknown-unknown/release/typst_hl.wasm --out-dir web/typst_hl --target web --no-typescript

build-linux:
	@AR_wasm32_unknown_unknown=llvm-ar \
	RANLIB_wasm32_unknown_unknown=llvm-ranlib \
	ARFLAGS_wasm32_unknown_unknown="--format=gnu" \
	CC_ENABLE_DEBUG_OUTPUT=1 \
	cargo build --target wasm32-unknown-unknown --release
	@wasm-bindgen target/wasm32-unknown-unknown/release/typst_hl.wasm --out-dir web/typst_hl --target web --no-typescript
