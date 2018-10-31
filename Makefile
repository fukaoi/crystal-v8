LIB_DIR   := $(PWD)/ext
NAME      := glue

.PHONY: full-build
full-build:
	export PATH=`pwd`/depot_tools:"$PATH"
	cd v8; ./tools/dev/v8gen.py x64.debug
	cd v8; gn args out.gn/x64.debug
	cd v8; ninja -C out.gn/x64.debug
	cd v8;  g++ -I. -Iinclude -c ../src/jslib.cc -fPIC -o ../src/jslib.o -Lout.gn/x64.debug/obj/ -pthread -std=c++0x
	crystal build src/$(NAME).cr -o bin/$(NAME)

.PHONY: build
build:
	cd v8;  g++ -I. -Iinclude -c ../src/jslib.cc -o ../src/jslib.o -Lout.gn/x64.debug/obj/ -pthread -std=c++0x
	crystal build src/$(NAME).cr -o bin/$(NAME)

.PHONY: run
run:
	cp -r v8/out.gn/x64.debug/lib*.so $(LIB_DIR)
	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(LIB_DIR)
	./bin/$(NAME)


.PHONY: install
install:
	@if [ ! -d depot_tools ]; then \
		git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git; \
        fi

	$(shell export PATH=$PWD/depot_tools:$PATH)
        
	@if [ ! -d v8 ]; then \
		fetch v8; \
        fi
	cd v8; gclient sync

.PHONY: clean
clean:
	rm -rf bin/*

.PHONY: full-clean
full-clean:
	rm -rf bin/*
	rm -rf v8/out.gn
