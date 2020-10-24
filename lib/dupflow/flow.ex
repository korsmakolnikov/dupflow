defmodule Dupflow.MyFlow do
  @moduledoc false

  require Logger

  def start() do
    :dets.open_file(:debug, type: :set)

    Flow.from_stages([Dupflow.Start], min_demand: 0, max_demand: 1)
    |> Flow.map(fn e ->
      GenServer.cast(Dupflow.Guard, {:dispatch, e})
      e
    end)
    |> Flow.map(&checkpoint/1)
    |> Flow.flat_map(fn x ->
      [x, x, x]
    end)
    |> Flow.flat_map(fn x ->
      [x, x, x]
    end)
    |> Flow.map(fn x ->
      # :timer.sleep(500)
      x
    end)
    |> Flow.partition(key: fn {k, _} -> k end)
    |> Flow.into_stages([Dupflow.End], name: __MODULE__)
  end

  def checkpoint({uuid, _} = x) do
    true = :dets.insert_new(:debug, {uuid})
    x
  rescue
    e ->
      Logger.error("the winner is #{uuid}, error: #{inspect(e)}")
      GenServer.cast(Dupflow.Guard, {:dup, x})
      x
  end
end
