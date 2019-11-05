defmodule Hello.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    import Supervisor.Spec

    children = [
      # Starts the Subscriber by calling: Hello.Subscriber.start_link(arg)
      worker(Extreme, [Application.get_env(:extreme, :event_store), [name: Hello.EventStore]]),
      {Hello.Subscriber, Hello.EventStore}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Hello.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
