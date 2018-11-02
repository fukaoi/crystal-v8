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
  int flags = 0;

  int jsparser(const char *code, v8::Isolate *isolate)
  {
    {
      v8::Isolate::Scope isolate_scope(isolate);
      // Create a stack-allocated handle scope.
      v8::HandleScope handle_scope(isolate);
      v8::Local<v8::Context> context = v8::Context::New(isolate);

      // Enter the context for compiling and running the hello world script.
      v8::Context::Scope context_scope(context);
      // Create a string containing the JavaScript source code.
      v8::Local<v8::String> source =
          v8::String::NewFromUtf8(isolate, code,
                                  v8::NewStringType::kNormal)
              .ToLocalChecked();
      // Compile the source code.
      v8::Local<v8::Script> script =
          v8::Script::Compile(context, source).ToLocalChecked();
      // Run the script to get the result.
      v8::Local<v8::Value> result = script->Run(context).ToLocalChecked();
      v8::String::Utf8Value utf8(isolate, result);
      printf("%s\n", *utf8);
    }
    return 0;
  }

  void jslib(char *code)
  {
    // Initialize V8.
    v8::V8::InitializeICUDefaultLocation("./bin/glue");
    v8::V8::InitializeExternalStartupData("./bin/glue");
    std::unique_ptr<v8::Platform> platform = v8::platform::NewDefaultPlatform();
    v8::V8::InitializePlatform(platform.get());
    v8::V8::Initialize();

    v8::Isolate::CreateParams create_params;
    create_params.array_buffer_allocator =
        v8::ArrayBuffer::Allocator::NewDefaultAllocator();
    if (!isolate)
    {
      std::cout << "*** Created isolate ***" << std::endl;
      isolate = v8::Isolate::New(create_params);
    }
    delete create_params.array_buffer_allocator;

    jsparser(code, isolate);

    v8::V8::Dispose();
    v8::V8::ShutdownPlatform();
  }
}
