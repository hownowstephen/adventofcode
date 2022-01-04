run2wyvern:
	~/Downloads/WyvernDemo20180325/bin/wyvern part2.wyv

run2: part2.wasm
	wasm-interp part2.wasm --run-all-exports

part2.wasm:
	wat2wasm part2.wat

run: part1.wasm
	wasm-interp part1.wasm --run-all-exports

part1.wasm:
	wat2wasm part1.wat

clean:
	rm *.wasm; true