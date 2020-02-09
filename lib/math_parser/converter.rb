module MathParser::Converter
  EXPR_BEG = 1
  EXPR_END = 2
  EXPR_ARG = 16
  EXPR_LABEL = 1024

  def convert(tokens)
    previous_numeric = false
    tokens.map do |token|
      next if space?(token)

      if currently_numeric?(token) && previous_numeric
        previous_numeric = false
        ["*", token[2]]
      else
        previous_numeric = currently_numeric?(token)
        token[2]
      end
    end.compact.join " "
  end

  def reparse(exp)
    tokens = Ripper.lex(exp)
    converted_exp = convert(tokens)
    original_exp = tokens.map { |token| token[2] unless token[2] == " " }.compact.join " "
    exp.sub!(original_exp, converted_exp)
    Ripper.sexp(exp).nil? ? reparse(exp) : exp
  end

private

  def currently_numeric?(token)
    ref_variable?(token) || int?(token) || float?(token) || rational?(token)
  end

  def space?(token)
    token[1] == :on_sp
  end

  def ref_variable?(token)
    (token[1] == :on_ident) && [EXPR_END, (EXPR_END | EXPR_LABEL), EXPR_ARG].include?(token[3])
  end

  def int?(token)
    token[1] == :on_int
  end

  def float?(token)
    token[1] == :on_float
  end

  def rational?(token)
    token[1] == :on_rational
  end
end
