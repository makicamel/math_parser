module MathParser::Converter
  EXPR_BEG = 1
  EXPR_END = 2
  EXPR_ARG = 16
  EXPR_LABEL = 1024

  def convert(tokens)
    lines = []
    tokens.last[0][0].times do |i|
      line_no = i + 1
      previous_numeric = false
      line = []
      # TODO: It may be better to separate tokens by line_no
      tokens.map do |token|
        next  if line_no > token[0][0]
        break if line_no < token[0][0]

        if space?(token)
          line << token[2]
        elsif currently_numeric?(token) && previous_numeric
          previous_numeric = true
          line << ["*", token[2]]
        else
          previous_numeric = currently_numeric?(token)
          line << token[2]
        end
      end
      lines << line.join("")
    end
    lines.join("")
  end

  def reparse(program)
    tokens = Ripper.lex(program)
    converted_program = convert(tokens)
    original_program = tokens.map { |token| token[2] }.join ""
    program.sub!(original_program, converted_program)
    Ripper.sexp(program).nil? ? reparse(program) : program
  end

private

  def currently_numeric?(token)
    ref_variable?(token) || int?(token) || float?(token) || rational?(token)
  end

  def space?(token)
    [:on_sp, :on_nl, :on_ignored_nl].include? token[1]
  end

  def ref_variable?(token)
    (token[1] == :on_ident) && [(EXPR_END | EXPR_LABEL), EXPR_ARG].include?(token[3])
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
