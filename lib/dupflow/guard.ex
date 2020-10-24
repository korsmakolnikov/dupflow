defmodule Dupflow.Guard do
  use GenServer

  def start_link(_),
    do:
      GenServer.start_link(
        __MODULE__,
        %{
          dispatched_events: 0,
          dispatched_events_list: [],
          worked_events: 0,
          worked_events_list: [],
          dup_events: 0,
          dup_events_list: []
        },
        name: __MODULE__
      )

  def init(state), do: {:ok, state}

  def handle_cast(
        {:dispatch, event},
        %{dispatched_events: dispatched_events, dispatched_events_list: dispatched_events_list} =
          state
      ),
      do:
        {:noreply,
         %{
           state
           | dispatched_events: dispatched_events + 1,
             dispatched_events_list: dispatched_events_list ++ [event]
         }}

  def handle_cast(
        {:work, event},
        %{worked_events: worked_events, worked_events_list: worked_events_list} = state
      ),
      do:
        {:noreply,
         %{
           state
           | worked_events: worked_events + 1,
             worked_events_list: worked_events_list ++ [event]
         }}

  def handle_cast(
        {:dup, event},
        %{dup_events: dup_events, dup_events_list: dup_events_list} = state
      ),
      do:
        {:noreply,
         %{
           state
           | dup_events: dup_events + 1,
             dup_events_list: dup_events_list ++ [event]
         }}

  def handle_call(:report, _from, state), do: {:reply, state, state}

  def report, do: GenServer.call(__MODULE__, :report)
end
