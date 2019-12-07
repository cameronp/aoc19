defmodule AdventOfCode.Day07 do
  alias Intcode.{Cpu, Memory}

  def part1(input) do
    cpu =
      input
      |> boot()

    all_combos(0..4)
    |> Enum.map(fn p -> {p, try_phases(cpu, p)} end)
    |> Enum.max_by(fn {_, val} -> val end)
  end

  def part2(input) do
    # try_feedback_phases([9, 7, 8, 5, 6], cpus)

    all_combos(5..9)
    |> Enum.map(fn phases -> {phases, try_feedback_phases(phases, input)} end)
    |> Enum.max_by(fn {_, v} -> v end)
  end

  def try_feedback_phases(phases, input) do
    [pa, pb, pc, pd, pe] = phases
    [a, b, c, d, e] = 0..4 |> Enum.map(fn _ -> input |> boot end)

    a = Cpu.connect_vm_socket_out(a, b.vm_socket_in) |> Cpu.preload_input([pa, 0])
    b = Cpu.connect_vm_socket_out(b, c.vm_socket_in) |> Cpu.preload_input([pb])
    c = Cpu.connect_vm_socket_out(c, d.vm_socket_in) |> Cpu.preload_input([pc])
    d = Cpu.connect_vm_socket_out(d, e.vm_socket_in) |> Cpu.preload_input([pd])

    e =
      Cpu.connect_vm_socket_out(e, a.vm_socket_in)
      |> Cpu.preload_input([pe])
      |> Cpu.monitor(self())

    [a, b, c, d, e]
    |> Enum.map(fn cpu -> spawn(fn -> Cpu.run(cpu) end) end)

    receive do
      {:halt, output} ->
        output |> hd()
    end
  end

  def all_combos(range) do
    phases = range |> Enum.to_list()

    for a <- phases,
        b <- phases -- [a],
        c <- phases -- [a, b],
        d <- phases -- [a, b, c],
        e <- phases -- [a, b, c, d],
        do: [a, b, c, d, e]
  end

  def try_phases(cpu, phases) do
    phases
    |> Enum.reduce(0, fn phase, input ->
      run(cpu, phase, input)
    end)
  end

  def run(cpu, phase, input) do
    cpu
    |> Cpu.preload_input([phase, input])
    |> Cpu.run()
    |> (fn c -> c.output |> hd() end).()
  end

  def boot(program) do
    program
    |> Memory.load()
    |> Cpu.boot()
    |> Cpu.start_vm_socket_in()
  end
end
