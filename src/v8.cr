require "./v8/libv8"

module V8
  class JS
    def initialize
      LibV8.init
    end

    def eval(code : String)
      pointer = LibV8.eval(code)
      String.new(pointer)
    rescue exception
      !pp "todo: #{exception}"
    end

    def destructor
      LibV8.destroy
    end
  end
end
