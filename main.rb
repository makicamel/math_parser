require "./mathruby"

module MyCalcurator
  def evaluate(tree, genv, lenv)
    case tree[0]
    when "lit"
      tree[1]
    when "+"
      evaluate(tree[1], genv, lenv) + evaluate(tree[2], genv, lenv)
    when "-"
      evaluate(tree[1], genv, lenv) - evaluate(tree[2], genv, lenv)
    when "*"
      evaluate(tree[1], genv, lenv) * evaluate(tree[2], genv, lenv)
    when "/"
      evaluate(tree[1], genv, lenv) / evaluate(tree[2], genv, lenv)
    when "**"
      evaluate(tree[1], genv, lenv)**evaluate(tree[2], genv, lenv)
    when "%"
      evaluate(tree[1], genv, lenv) % evaluate(tree[2], genv, lenv)
    when "<"
      evaluate(tree[1], genv, lenv) < evaluate(tree[2], genv, lenv)
    when "<="
      evaluate(tree[1], genv, lenv) <= evaluate(tree[2], genv, lenv)
    when ">"
      evaluate(tree[1], genv, lenv) > evaluate(tree[2], genv, lenv)
    when ">="
      evaluate(tree[1], genv, lenv) >= evaluate(tree[2], genv, lenv)
    when "=="
      evaluate(tree[1], genv, lenv) == evaluate(tree[2], genv, lenv)
    when "!="
      evaluate(tree[1], genv, lenv) != evaluate(tree[2], genv, lenv)
    when "stmts"
      i = 1
      last = nil
      while tree[i]
        last = evaluate(tree[i], env)
        i += 1
      end
      last
    when "var_assign"
      env[tree[1]] = evaluate(tree[2], genv, lenv)
    when "var_ref"
      env[tree[1]]
    when "func_call"
      p evaluate(tree[2], genv, lenv)
    when "if"
      if evaluate(tree[1], genv, lenv)
        evaluate(tree[2], genv, lenv)
      else
        evaluate(tree[3], genv, lenv)
      end
    when "while"
      while evaluate(tree[1], genv, lenv)
        evaluate(tree[2], genv, lenv)
      end
    else
      p "Unsupported operator: '#{tree[0]}'"
      pp tree
    end
  end

  def mp(exp = nil)
    tree = MathRubyParser.mathruby_parse(exp)
    genv = { "p" => ["builtin", "p"] }
    lenv = {}
    evaluate(tree, genv, lenv)
  end
end

include MyCalcurator
