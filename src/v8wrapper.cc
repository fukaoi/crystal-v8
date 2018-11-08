#include <stdlib.h>
#include <string.h>
#include <iostream>
#include <libplatform/libplatform.h>
#include <v8.h>

using namespace std;
using namespace v8;

static Platform *m_platform;

static Isolate *isolate;
static Persistent<v8::Context> context;

extern "C" void init(const char *path)
{
  class Allocator : public ArrayBuffer::Allocator
  {
  public:
    void *Allocate(size_t length) { return new char[length]; }

    void *AllocateUninitialized(size_t length) { return new char[length]; }

    virtual void Free(void *data, size_t length)
    {
      delete[] static_cast<char *>(data);
    }
  };

  V8::InitializeICU(path);
  V8::InitializeExternalStartupData(path);

  m_platform = platform::CreateDefaultPlatform();
  V8::InitializePlatform(m_platform);
  V8::Initialize();

  V8::InitializeExternalStartupData(path);

  Isolate::CreateParams create_params;
  create_params.array_buffer_allocator = new Allocator();
  isolate = Isolate::New(create_params);

  Isolate::Scope isolate_scope(isolate);
  HandleScope handle_scope(isolate);
  context.Reset(isolate, Context::New(isolate));
}

extern "C" void destroy()
{
  isolate->Dispose();
  V8::Dispose();
  V8::ShutdownPlatform();
  delete m_platform;
}

extern "C" void eval(const char *src)
{
  Isolate::Scope isolate_scope(isolate);
  HandleScope handle_scope(isolate);
  Context::Scope context_scope(context.Get(isolate));

  Local<Script> script =
      Script::Compile(isolate->GetCurrentContext(),
                      String::NewFromUtf8(isolate, src))
          .ToLocalChecked();

  Local<Value> result = script->Run(isolate->GetCurrentContext()).ToLocalChecked();
  String::Utf8Value utf8(isolate, result);
  printf("%s\n", *utf8);
}
