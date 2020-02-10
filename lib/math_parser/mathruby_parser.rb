require "minruby"
require "math_parser/converter"

module MathParser
  include Converter

  class MathRubyParser < MinRubyParser

    def self.mathruby_parse(program)
      new.mathruby_parse(program)
    end

    def mathruby_parse(program)
      converted_program = Ripper.sexp(program) ? program : reparse(program.strip)
      simplify(Ripper.sexp(converted_program))
    end

    def simplify(exp)
      case exp[0]
      when :opassign
        case exp[1][0]
        when :var_field
          var = exp[1][1][1]
          op = exp[2][1][0..-2]
          ["var_assign", var, [op, ["var_ref", var], simplify(exp[3])]]
        else
          raise
        end
      else
        super
      end
    end
  end
end
