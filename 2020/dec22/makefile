run: part1.wasm
	wasm-interp part1.wasm --run-all-exports

part1.wasm:
	wat2wasm part1.wat

clean:
	rm *.wasm; true