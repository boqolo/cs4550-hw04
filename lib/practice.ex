defmodule Practice do
  @moduledoc """
  Practice keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  alias Practice.{Calc, Factor, Palindrome}

  def double(x) do
    2 * x
  end

  def calc(expr) do
    Calc.calc(expr)
  end

  def factor(x) do
    Factor.factor(x)
  end

  def palindrome?(str) do
    Palindrome.palindrome?(str)
  end
end
