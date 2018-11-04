#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <iostream>
#include <sstream>
#include "libplatform/libplatform.h"
#include "v8.h"

extern "C"
{

  v8::Isolate *isolate;
  v8::Isolate::CreateParams create_params;

  void init() {
    // Initialize V8.
    v8::V8::InitializeICUDefaultLocation("./bin/glue");
    v8::V8::InitializeExternalStartupData("./bin/glue");
    std::unique_ptr<v8::Platform> platform = v8::platform::NewDefaultPlatform();
    v8::V8::InitializePlatform(platform.get());
    v8::V8::Initialize();

    create_params.array_buffer_allocator =
        v8::ArrayBuffer::Allocator::NewDefaultAllocator();
    isolate = v8::Isolate::New(create_params);
    isolate->Enter();
  }

  void run(const char *code)
  {
    {
      v8::Isolate::Scope isolate_scope(isolate);
      v8::HandleScope handle_scope(isolate);
      v8::Local<v8::Context> context = v8::Context::New(isolate);
      context->Enter();
      v8::Context::Scope context_scope(context);
  
      v8::Local<v8::String> source =
          v8::String::NewFromUtf8(isolate, code,
                                  v8::NewStringType::kNormal)
              .ToLocalChecked();
      v8::Local<v8::Script> script =
          v8::Script::Compile(context, source).ToLocalChecked();
      v8::Local<v8::Value> result = script->Run(context).ToLocalChecked();
      v8::String::Utf8Value utf8(isolate, result);
      printf("%s\n", *utf8);
    }
  }

  void finalyze() {
    v8::V8::Dispose();
    v8::V8::ShutdownPlatform();
    delete create_params.array_buffer_allocator;
  }
}
