#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>
#include <sstream>
#include "libplatform/libplatform.h"
#include "v8.h"
#include "unistd.h"

using namespace v8;

extern "C"
{
  int jsparser(const char *code, v8::Isolate *isolate)
  {

    Locker locker(isolate);
    isolate->Enter();
    isolate = Isolate::GetCurrent();
    Isolate::Scope isolate_scope(isolate);
    HandleScope handle_scope(isolate);
    Local<Context> context = Context::New(isolate);
    Context::Scope context_scope(context);
    {
      Local<String> source =
          String::NewFromUtf8(isolate, code,
                              NewStringType::kNormal)
              .ToLocalChecked();
      Local<Script> script =
          v8::Script::Compile(context, source).ToLocalChecked();
      Local<v8::Value> result = script->Run(context).ToLocalChecked();
      String::Utf8Value utf8(isolate, result);
      printf("%s\n", *utf8);
    }
    isolate->Exit();
    return 0;
  }

  void run(const char *code)
  {
    V8::InitializeICUDefaultLocation("./bin/glue");
    V8::InitializeExternalStartupData("./bin/glue");
    std::unique_ptr<Platform> platform = platform::NewDefaultPlatform();
    V8::InitializePlatform(platform.get());
    V8::Initialize();

    Isolate::CreateParams create_params;
    create_params.array_buffer_allocator =
        ArrayBuffer::Allocator::NewDefaultAllocator();
    static Isolate *isolate = Isolate::New(create_params);
    jsparser(code, isolate);
    V8::Dispose();
    V8::ShutdownPlatform();
    delete create_params.array_buffer_allocator;
  }

  void init() {}
  void finalyze() {}
}