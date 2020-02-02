require "minruby"

module MyCalcurator
  def evaluate(tree, env)
    case tree[0]
    when "lit"
      tree[1]
    when "+"
      evaluate(tree[1], env) + evaluate(tree[2], env)
    when "-"
      evaluate(tree[1], env) - evaluate(tree[2], env)
    when "*"
      evaluate(tree[1], env) * evaluate(tree[2], env)
    when "/"
      evaluate(tree[1], env) / evaluate(tree[2], env)
    when "**"
      evaluate(tree[1], env)**evaluate(tree[2], env)
    when "%"
      evaluate(tree[1], env) % evaluate(tree[2], env)
    when "<"
      evaluate(tree[1], env) < evaluate(tree[2], env)
    when "<="
      evaluate(tree[1], env) <= evaluate(tree[2], env)
    when ">"
      evaluate(tree[1], env) > evaluate(tree[2], env)
    when ">="
      evaluate(tree[1], env) >= evaluate(tree[2], env)
    when "=="
      evaluate(tree[1], env) == evaluate(tree[2], env)
    when "stmts"
      i = 1
      last = nil
      while tree[i]
        last = evaluate(tree[i], env)
        i += 1
      end
      last
    when "var_assign"
      env[tree[1]] = evaluate(tree[2], env)
    when "var_ref"
      env[tree[1]]
    when "func_call"
      p evaluate(tree[2], env)
    else
      p "Unsupported operator: '#{tree[0]}'"
      pp tree
    end
  end

  def parse(exp)
    tree = minruby_parse(exp)
    env = {}
    evaluate(tree, env)
  end
end

include MyCalcurator
