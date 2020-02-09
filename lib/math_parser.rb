require "math_parser/version"
require "math_parser/mathruby_parser"

module MathParser
  class Error < StandardError; end

  def mp(exp)
    tree = MathRubyParser.mathruby_parse(exp)
    evaluate(tree, {}, {})
  end

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
        last = evaluate(tree[i], genv, lenv)
        i += 1
      end
      last
    when "var_assign"
      lenv[tree[1]] = evaluate(tree[2], genv, lenv)
    when "var_ref"
      lenv[tree[1]]
    when "func_def"
      genv[tree[1]] = ["user_defined", tree[2], tree[3]]
    when "func_call"
      args = tree[2..].map { |t| evaluate(t, genv, lenv) }
      # 組み込み関数
      if respond_to?(tree[1]) || Kernel.respond_to?(tree[1])
        send(tree[1], *args)
      # ユーザ定義関数
      elsif genv.has_key? tree[1]
        func_lenv = {}
        mhd = genv[tree[1]]
        params = mhd[1]
        params.each_with_index { |param, j| func_lenv[param] = args[j] }
        evaluate(mhd[2], genv, func_lenv)
      # 未定義の場合は tree を変更して再度 evaluate する
      else
        new_tree = ["*", ["var_ref", tree[1]], tree[2]]
        evaluate(new_tree, genv, lenv)
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
end

include MathParser
