defmodule GenServerConcurrency do
  @moduledoc """
  Documentation for `GenServer`
  """

  use GenServer

  def start_link(initial_count) do
    GenServer.start_link(__MODULE__, initial_count)
  end

  def increment(pid) do
    GenServer.call(pid, :increment)
  end

  def decrement(pid) do
    GenServer.call(pid, :decrement)
  end

  def get_count(pid) do
    GenServer.call(pid, :get_count)
  end

  @impl true
  def handle_call(:increment, _from, count) do
    new_count = count + 1
    {:reply, new_count, new_count}
  end

  @impl true
  def handle_call(:decrement, _from, count) do
    new_count = count - 1
    {:reply, new_count, new_count}
  end

  @impl true
  def handle_call(:get_count, _from, count) do
    {:reply, count, count}
  end
end
