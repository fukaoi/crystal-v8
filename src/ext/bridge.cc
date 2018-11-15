#include "bridge.h"

static Platform *m_platform;
static Isolate *isolate;
static Persistent<v8::Context> context;

void init()
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
 
  m_platform = platform::CreateDefaultPlatform();
  V8::InitializePlatform(m_platform);
  V8::Initialize();

  Isolate::CreateParams create_params;
  create_params.array_buffer_allocator = new Allocator();
  isolate = Isolate::New(create_params);

  Isolate::Scope isolate_scope(isolate);
  HandleScope handle_scope(isolate);
  context.Reset(isolate, Context::New(isolate));
}

void destroy()
{
  context.Reset();
  isolate->Dispose();
  V8::Dispose();
  V8::ShutdownPlatform();
  delete m_platform;
}

const char* eval(const char *src)
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
  const char* str = to_c_string(utf8);
  return str;
}

// Utilitiy funciton
const char* to_c_string(const String::Utf8Value& value) {
  const char* val = *value ? *value : "<Failed convert>";
  char *setval = new char [strlen(val)+1];
  strcpy(setval,val);
  return (const char*)setval;
}