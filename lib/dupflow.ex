defmodule Dupflow do
  def push(n)
      when n > 0 do
    0..3
    |> Enum.each(fn _ ->
      msg =
        ?a..?z
        |> Enum.shuffle()
        |> Enum.take(10)

      GenStage.cast(Dupflow.Start, {:push, {UUID.uuid4(), msg}})
    end)

    push(n - 1)
  end

  def push(0), do: nil
end
