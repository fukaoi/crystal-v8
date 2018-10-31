#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "libplatform/libplatform.h"
#include "v8.h"

extern "C"
{
  int jsparser(const char *code, v8::Isolate *isolate)
  {
    // Create a new Isolate and make it the current one.

    {
      v8::Isolate::Scope isolate_scope(isolate);
      // Create a stack-allocated handle scope.
      v8::HandleScope handle_scope(isolate);
      // Create a new context.
      v8::Local<v8::Context> context = v8::Context::New(isolate);
      context->Enter();
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
      // Convert the result to an UTF8 string and print it.
      v8::String::Utf8Value utf8(isolate, result);
      printf("%s\n", *utf8);
    }
    // Dispose the isolate and tear down V8.
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
    v8::Isolate *isolate = v8::Isolate::New(create_params);
    isolate->Enter();
    jsparser(code, isolate);
    // isolate->Dispose();
    v8::V8::Dispose();
    v8::V8::ShutdownPlatform();
    delete create_params.array_buffer_allocator;
  }
}
