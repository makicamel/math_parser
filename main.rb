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
      args = tree[2..].map { |t| evaluate(t, genv, lenv) }
      if respond_to?(tree[1]) || Kernel.respond_to?(tree[1])
        send(tree[1], *args)
      else
      end
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
    evaluate(tree, {}, {})
  end
end

include MyCalcurator
