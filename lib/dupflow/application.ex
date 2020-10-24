defmodule Dupflow.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Dupflow.Start,
      Dupflow.End,
      Dupflow.Guard
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dupflow.Supervisor]
    Supervisor.start_link(children, opts)
    Dupflow.MyFlow.start()
  end
end
