defmodule Practice.Palindrome do
  def palindrome?(str) do
    String.graphemes(str) == Enum.reverse(String.graphemes(str))
  end
end
