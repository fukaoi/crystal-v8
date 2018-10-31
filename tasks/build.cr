class Build < LuckyCli::Task
  banner "C++,Crystal build"
  TOOLS_DIR = "./tools"

  def call
  end
end

# build:
# 	export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$(LIB_DIR)
# 	cp -r v8/out.gn/x64.debug/lib*.so $(LIB_DIR)
# 	cd v8;  g++  -shared -I. -Iinclude -c ../src/jslib.cc -o ../ext/jslib.o -L../ext -lv8_libplatform -licui18n -licuuc -lv8_libbase -lv8 -pthread -std=c++0x
# 	crystal build src/$(NAME).cr -o bin/$(NAME)
