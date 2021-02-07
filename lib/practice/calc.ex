defmodule Practice.Calc do
  def parse_float(text) do
    {num, _} = Float.parse(text)
    num
  end

  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    expr
    |> String.split(~r/\s+/) # splitting on all whitespace here
    # |> Enum.chunk_by(fn(c) -> String.contains?(c, ["+", "-"]) end)
    # |> hd
    |> shuntingYard([], [])
    # |> inspect
    # |> parse_float
    # |> :math.sqrt()

    # Hint:
    # expr
    # |> split
    # |> tag_tokens  (e.g. [+, 1] => [{:op, "+"}, {:num, 1.0}]
    # |> convert to postfix
    # |> reverse to prefix
    # |> evaluate as a stack calculator using pattern matching
  end

  defp number?(strTok) do
    Float.parse(strTok) != :error
  end

  defp operator?(strTok) do
    String.contains?("+-*/", strTok) && String.length(strTok) == 1
  end

  defp greaterThanEqPrecedence?(thisOperator, thatOperator) do
    precedence = %{"+" => 1, "-" => 1, "*" => 2, "/" => 2}
    precedence[thisOperator] <= precedence[thatOperator]
  end

  defp shuntingYard(exprArr, output, stack) do
    inspect(exprArr)
    cond do
      length(exprArr) == 0 -> output ++ stack
      number?(hd(exprArr)) -> shuntingYard(tl(exprArr), output ++ [hd(exprArr)], stack)
      operator?(hd(exprArr)) -> opsGreaterThanEqPrecedence = Enum.take_while(stack,
                                  fn(operator) -> greaterThanEqPrecedence?(hd(exprArr), operator) end)
                                shuntingYard(tl(exprArr),
                                             output ++ opsGreaterThanEqPrecedence,
                                             [hd(exprArr) | Enum.drop(stack, length(opsGreaterThanEqPrecedence))])
      # TODO: catch all case
    end
  end
end
