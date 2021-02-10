defmodule Practice.Factor do
  def factor(x) do
    try do
      {x, _} = Integer.parse(x)
      accumulateFactors(x, [])
    rescue
      MatchError -> []
    end
  end

  defp accumulateFactors(x, acc) do
    mid = div(x, 2)
    potentialPrimeFactors = Enum.to_list(2..mid)
    nextDivisor = Enum.find(potentialPrimeFactors, -1, fn(n) -> rem(x, n) == 0 end)
    if nextDivisor == -1 do
      acc ++ [x]
    else
      accumulateFactors(div(x, nextDivisor), acc ++ [nextDivisor])
    end
  end
end
