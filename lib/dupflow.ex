defmodule Dupflow do
  def push(n)
      when n > 0 do
    0..3
    |> Enum.each(fn _ ->
      GenStage.cast(Dupflow.Start, {:push, {UUID.uuid4(), "testo libero"}})
    end)

    push(n - 1)
  end

  def push(0), do: nil
end
