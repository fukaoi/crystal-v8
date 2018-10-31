#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "libplatform/libplatform.h"
#include "v8.h"

extern "C"
{

  v8::Isolate* initialize(){
    std::unique_ptr<v8::Platform> platform = v8::platform::NewDefaultPlatform();
    v8::V8::InitializePlatform(platform.get());
    v8::V8::Initialize();

    // Isolate
    v8::Isolate::CreateParams create_params;
    create_params.array_buffer_allocator = v8::ArrayBuffer::Allocator::NewDefaultAllocator();
    return v8::Isolate::New(create_params);    
    // delete create_params.array_buffer_allocator;
  }


  void jslib(char* code)
  {
    v8::Isolate* isolate = initialize();
    // Isolate block
    {
    
      v8::Isolate::Scope isolate_scope(isolate);
      v8::HandleScope handle_scope(isolate);
      v8::Local<v8::Context> context = v8::Context::New(isolate);
      v8::Context::Scope context_scope(context);
      v8::Local<v8::String> source = v8::String::NewFromUtf8(
                                         isolate,
                                         code,
                                         v8::NewStringType::kNormal)
                                         .ToLocalChecked();
      v8::Local<v8::Script> script = v8::Script::Compile(context, source).ToLocalChecked();
      v8::Local<v8::Value> result = script->Run(context).ToLocalChecked();
      v8::String::Utf8Value utf8(isolate, result);
      printf("%s\n", *utf8);
    }
    // Dispose the isolate and tear down v8
    isolate->Dispose();
    v8::V8::Dispose();
    v8::V8::ShutdownPlatform();
  }
}