module MyTokenizer
  # Ignore multiple statements for now
  def evaluate(tokens)
    i = 0
    line_no = tokens[i][0][0]
    while line_no == tokens[i]&.first&.first
      p tokens[i]
      i += 1
    end
    tokens
  end

  def reparse(exp)
    tokens = Ripper.lex(exp)
    evaluate(tokens)
  end
end
