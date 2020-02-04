module MyTokenizer
  EXPR_BEG = 1
  EXPR_END = 2
  EXPR_LABEL = 1024

  # Ignore multiple statements for now
  def convert(tokens)
    i = 0
    line_no = tokens[i][0][0]
    previous_numeric = false
    statement = []
    while line_no == tokens[i]&.first&.first
      if space?(tokens[i])
        i += 1
        next
      end

      if currently_numeric?(tokens[i]) && previous_numeric
        statement << "*"
      end
      previous_numeric = currently_numeric?(tokens[i])
      statement << tokens[i][2]
      i += 1
    end
    statement.join " "
  end

  def reparse(exp)
    tokens = Ripper.lex(exp)
    convert(tokens)
  end

private

  def currently_numeric?(token)
    ref_variable?(token) || int?(token) || float?(token) || rational?(token)
  end

  def space?(token)
    token[1] == :on_sp
  end

  def ref_variable?(token)
    (token[1] == :on_ident) && (token[3] == EXPR_END | EXPR_LABEL)
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
