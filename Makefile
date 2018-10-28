.PHONY: build
build:
	cd v8; ./tools/dev/v8gen.py x64.release.sample
	cd v8; gn args out.gn/x64.release.sample
	cd v8; ninja -C out.gn/x64.release.sample v8_monolith		
	cd v8; g++ -I. -Iinclude ../src/hello-world.cc -o ../bin/hello_world -lv8_monolith -Lout.gn/x64.release.sample/obj/ -pthread -std=c++0x

.PHONY: install
install:

.PHONY: clean
clean:
	rm -rf bin/*

