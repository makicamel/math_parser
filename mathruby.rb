require "minruby"
require "./tokenizer"

class MathRubyParser < MinRubyParser
  include MyTokenizer
  attr_reader :program

  def self.mathruby_parse(program)
    new(program).mathruby_parse
  end

  def initialize(program)
    @program = program
  end

  def mathruby_parse
    simplify(Ripper.sexp(program))
  end

  def simplify(exp)
    nodes = reparse(program) if exp.nil?

    case exp&.first || nodes[0]
    when :opassign
      case exp[1][0]
      when :var_field
        var = exp[1][1][1]
        op = exp[2][1][0]
        ["var_assign", var, [op, ["var_ref", var], simplify(exp[3])]]
      else
        raise
      end
    else
      super
    end
  end
end
