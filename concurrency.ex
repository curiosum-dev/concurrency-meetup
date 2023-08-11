defmodule Concurrency do
  @moduledoc """
  Documentation for `Concurrency`.
  """

  # -------------- #
  # ASYNC STRATEGY #
  # -------------- #

  def add(first, second) do
    Process.sleep(3000)
    IO.puts(first + second)
  end

  def async_add(first, second) do
    spawn(fn -> add(first, second) end)
  end

  # ---------------------------- #
  # SIMPLE PROCESS COMMUNICATION #
  # ---------------------------- #

  def start_link do
    spawn(fn -> process_messages() end)
  end

  def process_messages do
    receive do
      {:message, message} ->
        IO.puts("Received: #{message} in process #{inspect(self())}")
        process_messages()

      {:exit, message} ->
        IO.puts("Ciao, #{inspect(message)}")
        Process.exit(self(), :normal)
    end
  end

  # --------------------------- #
  # TASK EXAMPLE - PARALLEL MAP #
  # --------------------------- #

  # sequential execution without concurrent
  def double_list do
    1..5
    |> Enum.map(&(double(&1)))
    |> IO.inspect(label: "result from double_list")
  end

  # concurrent execution with parallelism
  def async_double_list do
    1..5
    |> Enum.map(&(Task.async(fn -> double(&1) end)))
    |> Enum.map(&Task.await/1)
    |> IO.inspect(label: "result from async_double_list")
  end

  defp double(num) do
    IO.puts("Doubling #{num}")
    Process.sleep(3000)
    num * 2
  end

  """
  Benefits of parallel map:
  - improved performance (as utilizing multplie CPU cores and executing operations concurrently),
  - simpilified code (`Task.async/1` is pretty straightforward to introduce,
    and it does not require low-level concurrency management),
  - isolation and fault tolerance (one failure will not affect the entire system),
  - load balancing (distributing work evenly among processes - each process contributes equally)
  """
end
