defmodule Dupflow.End do
  @moduledoc false
  use GenStage

  def start_link(_) do
    GenStage.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def init(s) do
    {:consumer, s}
  end

  def handle_events(events, _from, state) do
    # IO.inspect(events, label: "handle_events")

    Enum.reduce(events, %{}, fn {uuid, i}, acc ->
      x =
        case Map.get(acc, uuid) do
          nil ->
            Map.put(acc, uuid, [i])

          _ ->
            Map.update!(acc, uuid, fn list -> list ++ [i] end)
        end

      GenServer.cast(Dupflow.Guard, {:work, i})
      x
    end)
    |> IO.inspect(label: "aggregate")

    {:noreply, [], state}
  end
end
