#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "libplatform/libplatform.h"
#include "v8.h"
#include "unistd.h"

using namespace v8;

Isolate *isolate;
Isolate::CreateParams create_params;
Local<Context> context;

void init()
{
  V8::Initialize();
}

void deinit()
{
  // isolate->Dispose();
  V8::Dispose();
  V8::ShutdownPlatform();
  delete create_params.array_buffer_allocator;
}

void run(const char *code)
{
  isolate->Enter();
  isolate = Isolate::GetCurrent();
  {
    context->Enter(); // if using in scope func, but ` signal SIGSEGV: invalid address (fault address: 0x0)`
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
    context->Exit();
  }
  isolate->Exit();
}

int count = 0;
void scope(const char* code)
{
  if (count == 0) {
    count++;
    init();
    std::unique_ptr<Platform> platform = platform::NewDefaultPlatform();
    V8::InitializePlatform(platform.get());
    create_params.array_buffer_allocator =
        ArrayBuffer::Allocator::NewDefaultAllocator();
    isolate = Isolate::New(create_params);
    Isolate::Scope isolate_scope(isolate);
    HandleScope handle_scope(isolate);
    context = Context::New(isolate);
  }
  run(code);
}

int main(int argc, char *argv[])
{
  scope("-100 * -1000");
  scope("var i = 1;while (i < 1000000) {i++;-100*9;}");
  scope("2 * 2");
  scope("10 + 20");
  scope("0.2 * 0.08");
  scope("class Person {constructor(name) {this.name = name;}sayHello() {return ('Hello, Im ' + this.getName());}getName() {return this.name;}}; new Person('山田敬三').sayHello();");

  deinit();
  return 0;
}
