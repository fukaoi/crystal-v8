#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "libplatform/libplatform.h"
#include "v8.h"
#include "unistd.h"

using namespace v8;

Isolate *isolate;
Isolate::CreateParams create_params;

void init() {
  V8::InitializeICUDefaultLocation("argv[0]");
  V8::InitializeExternalStartupData("argv[0]");

  std::unique_ptr<Platform> platform = platform::NewDefaultPlatform();
  V8::InitializePlatform(platform.get());
  V8::Initialize();

  create_params.array_buffer_allocator =
  ArrayBuffer::Allocator::NewDefaultAllocator();
  isolate = Isolate::New(create_params);
}

void deinit() {
  isolate->Dispose();
  V8::Dispose();
  V8::ShutdownPlatform();
  delete create_params.array_buffer_allocator;
}

int jslib(const char *code, v8::Isolate* isolate) {
  { 
    Isolate::Scope isolate_scope(isolate);
    HandleScope handle_scope(isolate);
    Local<Context> context = Context::New(isolate);
    Context::Scope context_scope(context);
    Local<String> source =
        String::NewFromUtf8(isolate, code,
                                NewStringType::kNormal)
            .ToLocalChecked();
    Local<Script> script =
        Script::Compile(context, source).ToLocalChecked();
    Local<Value> result = script->Run(context).ToLocalChecked();
    String::Utf8Value utf8(isolate, result);
    printf("%s\n", *utf8);
  }
  return 0;
}

int main(int argc, char *argv[])
{
  init();

  jslib("-100 * -1000", isolate);
  jslib("const i = 1; i + 100", isolate);
  jslib("2 * 2", isolate);
  jslib("10 + 20", isolate);
  jslib("0.2 * 0.08", isolate);
  jslib("class Person {constructor(name) {this.name = name;}sayHello() {return ('Hello, Im ' + this.getName());}getName() {return this.name;}}; new Person('山田敬三').sayHello();", isolate);

  deinit();
  return 0;
}


