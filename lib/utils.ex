defmodule Utils do
  def lines(file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
