defmodule Hello.Subscriber do
  @moduledoc """
  An example EventStore subscriber.
  """
  use GenServer

  require Logger

  @event_stream_id "hello"

  @doc """
  Starts the GenServer
  """
  @spec start_link(any()) :: {:ok, pid()}
  def start_link(args \\ :none) do
    Logger.debug("#{__MODULE__}.start_link(#{inspect(args)})")
    GenServer.start_link(__MODULE__, args, name: __MODULE__)
  end

  @doc false
  def init(server) do
    Logger.debug("#{__MODULE__}.init(#{inspect(server)})")
    Extreme.subscribe_to(server, self(), @event_stream_id)
    {:ok, server}
  end

  def handle_info({:on_event, event}, server) do
    Logger.debug(~s[New event added to stream "#{@event_stream_id}": #{inspect(event)}])
    Hello.print_event(event)
    {:noreply, server}
  end
end
