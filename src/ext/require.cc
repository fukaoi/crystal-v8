#include <string.h>
#include <assert.h>
#include "v8.h"

using namespace v8;

class Require
{
private:
  /* data */
public:
  Require();
  ~Require();
};

void Require(const FunctionCallbackInfo<Value> &args)
{
  for (int i = 0; i < args.Length(); i++)
  {
    HandleScope handle_scope(args.GetIsolate());
    String::Utf8Value file(args.GetIsolate(), args[i]);
    if (*file == NULL)
    {
      args.GetIsolate()->ThrowException(
          String::NewFromUtf8(args.GetIsolate(), "Error loading file",
                              NewStringType::kNormal)
              .ToLocalChecked());
      return;
    }
    Local<String> source;
    if (!ReadFile(args.GetIsolate(), *file).ToLocal(&source))
    {
      args.GetIsolate()->ThrowException(
          String::NewFromUtf8(args.GetIsolate(), "Error loading file",
                              NewStringType::kNormal)
              .ToLocalChecked());
      return;
    }
    if (!ExecuteString(args.GetIsolate(), source, args[i], false, false))
    {
      args.GetIsolate()->ThrowException(
          String::NewFromUtf8(args.GetIsolate(), "Error executing file",
                              NewStringType::kNormal)
              .ToLocalChecked());
      return;
    }
  }
}

MaybeLocal<String> ReadFile(Isolate *isolate, const char *name)
{
  FILE *file = fopen(name, "rb");
  if (file == NULL)
    return MaybeLocal<String>();

  fseek(file, 0, SEEK_END);
  size_t size = ftell(file);
  rewind(file);

  char *chars = new char[size + 1];
  chars[size] = '\0';
  for (size_t i = 0; i < size;)
  {
    i += fread(&chars[i], 1, size - i, file);
    if (ferror(file))
    {
      fclose(file);
      return MaybeLocal<String>();
    }
  }
  fclose(file);
  MaybeLocal<String> result = String::NewFromUtf8(
      isolate, chars, NewStringType::kNormal, static_cast<int>(size));
  delete[] chars;
  return result;
}

bool ExecuteString(Isolate *isolate, Local<String> source,
                   Local<Value> name, bool print_result,
                   bool report_exceptions)
{
  HandleScope handle_scope(isolate);
  TryCatch try_catch(isolate);
  ScriptOrigin origin(name);
  Local<Context> context(isolate->GetCurrentContext());
  Local<Script> script;
  if (!Script::Compile(context, source, &origin).ToLocal(&script))
  {
    // Print errors that happened during compilation.
    if (report_exceptions)
      ReportException(isolate, &try_catch);
    return false;
  }
  else
  {
    Local<Value> result;
    if (!script->Run(context).ToLocal(&result))
    {
      assert(try_catch.HasCaught());
      // Print errors that happened during execution.
      if (report_exceptions)
        ReportException(isolate, &try_catch);
      return false;
    }
    else
    {
      assert(!try_catch.HasCaught());
      if (print_result && !result->IsUndefined())
      {
        // If all went well and the result wasn't undefined then print
        // the returned value.
        v8::String::Utf8Value str(isolate, result);
        const char *cstr = ToCString(str);
        printf("%s\n", cstr);
      }
      return true;
    }
  }
}

void ReportException(Isolate *isolate, TryCatch *try_catch)
{
  HandleScope handle_scope(isolate);
  String::Utf8Value exception(isolate, try_catch->Exception());
  const char *exception_string = ToCString(exception);
  Local<Message> message = try_catch->Message();
  if (message.IsEmpty())
  {
    // V8 didn't provide any extra information about this error; just
    // print the exception.
    fprintf(stderr, "%s\n", exception_string);
  }
  else
  {
    // Print (filename):(line number): (message).
    String::Utf8Value filename(isolate,
                               message->GetScriptOrigin().ResourceName());
    Local<Context> context(isolate->GetCurrentContext());
    const char *filename_string = ToCString(filename);
    int linenum = message->GetLineNumber(context).FromJust();
    fprintf(stderr, "%s:%i: %s\n", filename_string, linenum, exception_string);
    // Print line of source code.
    String::Utf8Value sourceline(
        isolate, message->GetSourceLine(context).ToLocalChecked());
    const char *sourceline_string = ToCString(sourceline);
    fprintf(stderr, "%s\n", sourceline_string);
    // Print wavy underline (GetUnderline is deprecated).
    int start = message->GetStartColumn(context).FromJust();
    for (int i = 0; i < start; i++)
    {
      fprintf(stderr, " ");
    }
    int end = message->GetEndColumn(context).FromJust();
    for (int i = start; i < end; i++)
    {
      fprintf(stderr, "^");
    }
    fprintf(stderr, "\n");
    Local<Value> stack_trace_string;
    if (try_catch->StackTrace(context).ToLocal(&stack_trace_string) &&
        stack_trace_string->IsString() &&
        Local<String>::Cast(stack_trace_string)->Length() > 0)
    {
      String::Utf8Value stack_trace(isolate, stack_trace_string);
      const char *stack_trace_string = ToCString(stack_trace);
      fprintf(stderr, "%s\n", stack_trace_string);
    }
  }
}

Local<Context> SetupCustomFunction()
{
  Local<ObjectTemplate> global = ObjectTemplate::New(isolate);
  global->Set(String::NewFromUtf8(
                  isolate, "require", NewStringType::kNormal)
                  .ToLocalChecked(),
              FunctionTemplate::New(isolate, Require));
  return Context::New(isolate, NULL, global);
}