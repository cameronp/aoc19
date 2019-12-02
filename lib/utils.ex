defmodule Utils do
  def lines(file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  def lines(file, parser) do
    file
    |> lines()
    |> Enum.map(parser)
  end

  def csv(file, parser) do
    file
    |> File.read!()
    |> String.split(",")
    |> Enum.map(parser)
  end
end
