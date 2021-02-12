defmodule Practice.Calc do
  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    expr
    |> getListOfSplitOperatorsAndOperands()
    |> shuntingYard([], []) # arrange list of tokens into post-fix
    |> evalPostFixStrTokens([])
  end

  defp parseFloat(text) do
    {num, _} = Float.parse(text)
    num
  end

  defp interpose(e1, e2, acc) do
    cond do
      Enum.empty?(e1) -> acc ++ e2
      Enum.empty?(e2) -> acc ++ [hd(e1)]
      true -> interpose(tl(e1), tl(e2), acc ++ [hd(e1), hd(e2)])
    end
  end

  defp getListOfSplitOperatorsAndOperands(expr) do
    numToks = String.split(expr, ~r/\W/, trim: true) # get operand str toks
    opToks = String.split(expr, ~r/\s*\d*/, trim: true) # get operator toks
    interpose(numToks, opToks, [])
  end

  # Helper function which checks if a string can be parsed as a number.
  defp num?(strTok) do
    Float.parse(strTok) != :error
  end

  # Helper function which checks if a string is a valid operator token.
  defp op?(strTok) do
    String.contains?("+-*/", strTok) && String.length(strTok) == 1
  end

  # Helper function to determine if 'this' operator has greater or equal
  # precedence with 'that' operator in terms of order of operation.
  defp greaterThanEqPreced?(thisOperator, thatOperator) do
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
      num?(hd(exprArr)) -> shuntingYard(tl(exprArr),
                                        output ++ [hd(exprArr)],
                                        stack)
      # Depending on operator, push stack operators to output if greater
      # or equal precedence, push operator onto stack, recur
      op?(hd(exprArr)) -> opsGreaterThanEqPreced = Enum.take_while(stack, fn(op) -> 
                            greaterThanEqPreced?(hd(exprArr), op) end)
                          toDrop = length(opsGreaterThanEqPreced)
                          shuntingYard(tl(exprArr),
                                       output ++ opsGreaterThanEqPreced,
                                       [hd(exprArr) | Enum.drop(stack, toDrop)])
      # Skip unrecognized tokens
      true -> shuntingYard(tl(exprArr), output, stack)
    end
  end

  # Helper function to get the correct operands from the stack
  # during post-fix evaluation.
  defp getOperands(stack) do
    if length(stack) > 1 do
      Enum.reverse(Enum.take(stack, 2))
    else
      [0, 0] # return 0s if not enough operands (malformed expression)
    end
  end

  # Return the numerical value of a post-fix expression represented as
  # a list of string tokens (operators and operands).
  defp evalPostFixStrTokens(exprArr, stack) do
    if Enum.empty?(exprArr) do
        length(stack) > 0 && hd(stack)
    else
      case hd(exprArr) do
        # take 2, reverse, use as args, push result on stack, recur
        "+" -> [x, y] = getOperands(stack)
                        newStack = [(x + y) | Enum.drop(stack, 2)]
                        evalPostFixStrTokens(tl(exprArr), newStack)
        "-" -> [x, y] = getOperands(stack)
                        newStack = [(x - y) | Enum.drop(stack, 2)]
                        evalPostFixStrTokens(tl(exprArr), newStack)
        "*" -> [x, y] = getOperands(stack)
                        newStack = [(x * y) | Enum.drop(stack, 2)]
                        evalPostFixStrTokens(tl(exprArr), newStack)
        "/" -> [x, y] = getOperands(stack)
                        newStack = [(x / y) | Enum.drop(stack, 2)]
                        evalPostFixStrTokens(tl(exprArr), newStack)
        # convert and push operands onto stack
        _ -> parsedOperand = parseFloat(hd(exprArr))
             evalPostFixStrTokens(tl(exprArr), [parsedOperand | stack])
      end
    end
  end

end # end module
