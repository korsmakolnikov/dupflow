defmodule Dupflow.Start do
  @moduledoc false
  use GenStage

  def start_link(_),
    do: GenStage.start_link(__MODULE__, %{queue: [], remained: 0}, name: __MODULE__)

  @impl GenStage
  def init(empty_queue),
    do: {:producer, empty_queue}

  @impl GenStage
  def handle_cast({:push, msg}, %{queue: queue, remained: remained})
      when remained === 0 do
    IO.inspect(pass: :cast_0, q: Enum.count(queue), r: remained)
    {:noreply, [], %{queue: Enum.concat(queue, [msg]), remained: 0}}
  end

  @impl GenStage
  def handle_cast({:push, msg}, %{queue: queue, remained: remained}) do
    IO.inspect(pass: :cast_n, q: Enum.count(queue), r: remained)
    {:noreply, [msg], %{queue: queue, remained: remained - 1}}
  end

  @impl GenStage
  def handle_demand(demand, %{queue: queue, remained: remained}) do
    {events, leftover} = Enum.split(queue, demand + remained)
    new_remained = remained + demand - Enum.count(events)

    IO.inspect(
      pass: :demand,
      demand: demand,
      q: Enum.count(queue),
      r: remained,
      new_r: new_remained
    )

    {:noreply, events, %{queue: leftover, remained: new_remained}}
  end

  # def handle_cast({:push, e}, {q, r})
  #    when r === 0,
  #    do: {:noreply, q, {q ++ [e], 0}} |> IO.inspect(label: "handle_cast-n")

  # def handle_cast({:push, e}, {q, r}),
  #  do: {:noreply, [e], {q, r - 1}} |> IO.inspect(label: "handle_cast-0")

  # def handle_demand(demand, {q, r}) when demand > 0 do
  #  {events, leftover} = Enum.split(q, demand + r)
  #  IO.inspect({events, leftover}, label: "DIOCANE")
  #  new_r = r + demand - Enum.count(events)

  #  {:noreply, events, {leftover, new_r}}
  # end
end
