lib JS
  fun init : Void
  fun eval(code : LibC::Char*) : Void
  fun destroy : Void
end


module V8
  extend self
  def run(code : String)
    JS.init
    JS.eval(code)
    JS.destroy
  end
end

