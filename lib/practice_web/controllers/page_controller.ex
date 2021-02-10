defmodule PracticeWeb.PageController do
  use PracticeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def double(conn, %{"x" => x}) do
    {x, _} = Integer.parse(x)
    y = Practice.double(x)
    render conn, "double.html", x: x, y: y
  end

  def calc(conn, %{"expr" => expr}) do
    y = Practice.calc(expr)
    stripped = String.replace(expr, ~r/[\(\).]/, "") # strip parens
    render conn, "calc.html", expr: stripped, y: y
  end

  def factor(conn, %{"x" => x}) do
    factors = Practice.factor(x)
    y = Enum.join(factors, ", ")
    render conn, "factor.html", x: x, y: y
  end

  def palindrome?(conn, %{"str" => str}) do
    isPalindrome = Practice.palindrome?(str)
    res = if isPalindrome do
      "#{str} IS indeed a palindrome!"
    else
      "#{str} is sadly NOT a palindrome :-("
    end
    render conn, "palindrome.html", res: res
  end
end
