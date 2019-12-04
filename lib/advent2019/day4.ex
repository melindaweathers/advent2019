#mix run -e 'Day4.run'
defmodule Day4 do
  def valid_password?(password, check_separate_doubles) do
    [a,b,c,d,e,f] = get_digits(password)
    has_double = a == b || b == c || c == d || d == e || e == f
    increasing = a <= b && b <= c && c <= d && d <= e && e <= f
    has_double && increasing && (!check_separate_doubles || has_valid_double_digits?(a,b,c,d,e,f))
  end

  def has_valid_double_digits?(a, b, c, d, e, f) do
    (a == b && b != c) ||
      (a != b && b == c && c != d) ||
      (b != c && c == d && d != e) ||
      (c != d && d == e && e != f) ||
      (d != e && e == f)
  end

  def get_digits(password) do
    password
      |> Integer.to_string
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)
  end

  def check_range(from, to, check_separate_doubles) do
    Enum.map(from..to, fn(x) ->
      if valid_password?(x, check_separate_doubles), do: 1, else: 0
    end) |> Enum.sum
  end

  def run do
    IO.puts "Sample 1 - should be true"
    IO.puts valid_password?(111111, false)

    IO.puts "Sample 2 - should be false"
    IO.puts valid_password?(223450, false)

    IO.puts "Sample 3 - should be false"
    IO.puts valid_password?(123789, false)

    IO.puts "First star"
    IO.puts check_range(240298, 784956, false)

    IO.puts "Sample 1 - should be true"
    IO.puts valid_password?(112233, true)

    IO.puts "Sample 2 - should be false"
    IO.puts valid_password?(123444, true)

    IO.puts "Sample 3 - should be true"
    IO.puts valid_password?(111122, true)

    IO.puts "Second star"
    IO.puts check_range(240298, 784956, true)
  end
end
