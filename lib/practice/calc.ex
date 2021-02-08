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
    |> evalPostFixStrTokens([])
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

  # Helper function which checks if a string can be parsed as a number.
  defp number?(strTok) do
    Float.parse(strTok) != :error
  end

  # Helper function which checks if a string is a valid operator token.
  defp operator?(strTok) do
    String.contains?("+-*/", strTok) && String.length(strTok) == 1
  end

  # Helper function to determine if 'this' operator has greater or equal precedence with 'that' operator
  # in terms of order of operation.
  defp greaterThanEqPrecedence?(thisOperator, thatOperator) do
    precedence = %{"+" => 1, "-" => 1, "*" => 2, "/" => 2}
    precedence[thisOperator] <= precedence[thatOperator]
  end

  # My implementation of Dijkstra's Shunting Yard algorithm.
  # ref: https://en.wikipedia.org/wiki/Shunting-yard_algorithm
  # This function will return the list of string tokens of the expression
  # rearranged in post-fix notation.
  defp shuntingYard(exprArr, output, stack) do
    cond do
      Enum.empty?(exprArr) -> output ++ stack
      # Add to output and recur
      number?(hd(exprArr)) -> shuntingYard(tl(exprArr), output ++ [hd(exprArr)], stack)
      # Depending on operator, push stack operators to output if greater or equal precedence, push operator onto stack, recur
      operator?(hd(exprArr)) -> opsGreaterThanEqPrecedence = Enum.take_while(stack,
                                  fn(operator) -> greaterThanEqPrecedence?(hd(exprArr), operator) end)
                                shuntingYard(tl(exprArr),
                                             output ++ opsGreaterThanEqPrecedence,
                                             [hd(exprArr) | Enum.drop(stack, length(opsGreaterThanEqPrecedence))])
      # Skip unrecognized tokens
      true -> shuntingYard(tl(exprArr), output, stack)
    end
  end

  # Helper function to get the correct operands from the stack during post-fix evaluation.
  defp getOperands(stack) do
    Enum.reverse(Enum.take(stack, 2))
  end

  # Return the numerical value of a post-fix expression represented as a list of string tokens (operators and operands).
  defp evalPostFixStrTokens(exprArr, stack) do
    cond do
      Enum.empty?(exprArr) -> length(stack) > 0 && hd(stack)
      # take 2, reverse, use as args, push result on stack, recur
      String.equivalent?("+", hd(exprArr)) -> [x, y] = getOperands(stack)
                                              newStack = [(x + y) | Enum.drop(stack, 2)]
                                              evalPostFixStrTokens(tl(exprArr), newStack)
      String.equivalent?("-", hd(exprArr)) -> [x, y] = getOperands(stack)
                                              newStack = [(x - y) | Enum.drop(stack, 2)]
                                              evalPostFixStrTokens(tl(exprArr), newStack)
      String.equivalent?("*", hd(exprArr)) -> [x, y] = getOperands(stack)
                                              newStack = [(x * y) | Enum.drop(stack, 2)]
                                              evalPostFixStrTokens(tl(exprArr), newStack)
      String.equivalent?("/", hd(exprArr)) -> [x, y] = getOperands(stack)
                                              newStack = [(x / y) | Enum.drop(stack, 2)]
                                              evalPostFixStrTokens(tl(exprArr), newStack)
      # convert and push operands onto stack
      true -> parsedOperand = elem(Float.parse(hd(exprArr)), 0)
              evalPostFixStrTokens(tl(exprArr), [parsedOperand | stack])
    end
  end
end
