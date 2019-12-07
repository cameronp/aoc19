defmodule Intcode.VmSocket do
  def start(state) do
    pid = spawn(fn -> loop(state) end)
    pid
  end

  def write(pid, value) do
    send(pid, {:write, value})
  end

  def read(pid) do
    send(pid, {self(), :read})

    receive do
      {:ok, value} ->
        value
    end
  end

  defp loop(state) do
    receive do
      {:write, value} ->
        loop(state ++ [value])

      {sender, :read} ->
        case state do
          [h | t] ->
            send(sender, {:ok, h})
            loop(t)

          [] ->
            receive do
              {:write, value} ->
                send(sender, {:ok, value})
                loop([])
            end
        end
    end
  end
end
