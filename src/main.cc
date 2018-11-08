#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "libplatform/libplatform.h"
#include "v8.h"
#include "unistd.h"
#include <iostream>

using namespace v8;
using namespace std;

// Isolate *isolate;
// Isolate::CreateParams create_params;

// void deinit()
// {
//   // isolate->Dispose();
//   V8::Dispose();
//   V8::ShutdownPlatform();
//   delete create_params.array_buffer_allocator;
// }

// void run(const char *code)
// {

//   Isolate::Scope isolate_scope(isolate);
//   HandleScope handle_scope(isolate);
//   Local<Context> context = Context::New(isolate);
//   isolate->Enter();
//   isolate = Isolate::GetCurrent();
//   {
//     context->Enter(); // if using in scope func, but ` signal SIGSEGV: invalid address (fault address: 0x0)`
//     Context::Scope context_scope(context);
//     Local<String> source =
//         String::NewFromUtf8(isolate, code,
//                             NewStringType::kNormal)
//             .ToLocalChecked();
//     Local<Script> script =
//         Script::Compile(context, source).ToLocalChecked();
//     Local<Value> result = script->Run(context).ToLocalChecked();
//     String::Utf8Value utf8(isolate, result);
//     printf("%s\n", *utf8);
//     context->Exit();
//   }
//   isolate->Exit();
// }

class Demo
{
public:
  Isolate *isolate;
  Isolate::CreateParams create_params;
  Persistent<Context> context;

  Demo()
  {
    cout << "Dmoe test" << endl;
    V8::Initialize();
    std::unique_ptr<Platform> platform = platform::NewDefaultPlatform();
    V8::InitializePlatform(platform.get());
    create_params.array_buffer_allocator =
        ArrayBuffer::Allocator::NewDefaultAllocator();
    isolate = Isolate::New(create_params);
  }

  ~Demo()
  {
    isolate->Dispose();
    V8::Dispose();
    V8::ShutdownPlatform();
    delete create_params.array_buffer_allocator;
  }

  void exec(const char *code)
  {
    {
      Isolate::Scope isolate_scope(isolate);
      HandleScope handle_scope(isolate);
      // Local<Context> context = Context::New(isolate);
      auto context = Context::New(isolate);
      Context::Scope context_scope(context);
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
  }
};

int main(int argc, char *argv[])
{ 
  Demo demo;
  demo.exec("1 + 1");
  // V8::Initialize();
  // std::unique_ptr<Platform> platform = platform::NewDefaultPlatform();
  // V8::InitializePlatform(platform.get());
  // create_params.array_buffer_allocator =
  //     ArrayBuffer::Allocator::NewDefaultAllocator();
  // isolate = Isolate::New(create_params);

  // run("-100 * -1000");
  // run("var i = 1;while (i < 1000000) {i++;-100*9;}");
  // run("const i = 100;i - (-99999999)");
  // run("10 + 20");
  // run("0.2 * 0.08");

  // deinit();
  return 0;
}
