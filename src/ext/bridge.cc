#include <string>
#include "bridge.h"
#include "v8pp/context.hpp"
#include "v8pp/object.hpp"

int main(int argc, char const *argv[])
{
	// v8::V8::InitializeExternalStartupData(argv[0]);
	std::unique_ptr<v8::Platform> platform(v8::platform::CreateDefaultPlatform());
	v8::V8::InitializePlatform(platform.get());
	v8::V8::Initialize();

  v8pp::context context;
  v8::Isolate *isolate = context.isolate();
  v8::HandleScope scope(isolate);

  v8::Local<v8::Value> result = context.run_script("1+1");
  result = context.run_script("1+1");
  result = context.run_script("1+1");
  result = context.run_script("1+1");
  result = context.run_script("1+1");
  result = context.run_script("1+1");
  result = context.run_script("1+1");
  result = context.run_script("1+1");
  result = context.run_script("1+1");
  result = context.run_script("require('./index.js')");
  String::Utf8Value utf8(isolate, result);
  cout << *utf8 << endl;
  cout << 100 << endl;
  
  // isolate->Dispose();
  // V8::Dispose();
  // V8::ShutdownPlatform();
  return 0;
}
