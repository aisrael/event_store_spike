defmodule Hello do
  @moduledoc """
  Documentation for Hello.
  """

  alias Extreme.Msg, as: ExMsg

  require Logger

  # see application.ex
  @server Hello.EventStore

  @event_type "Hello"
  @event_stream_id "hello"

  @doc """
  Sends a `Hello` event to the `hello` EventStore stream
  """
  def hello(who \\ "world") do
    data = Msgpax.pack!(%{who: who}) |> IO.iodata_to_binary()

    proto_events = [
      ExMsg.NewEvent.new(
        event_id: Extreme.Tools.gen_uuid(),
        event_type: @event_type,
        data_content_type: 0,
        metadata_content_type: 0,
        data: data,
        metadata: ""
      )
    ]

    write_events =
      ExMsg.WriteEvents.new(
        event_stream_id: @event_stream_id,
        expected_version: -2,
        events: proto_events,
        require_master: false
      )

    Extreme.execute(@server, write_events)
  end

  def read_events(from \\ 0) do
    read_events =
      ExMsg.ReadStreamEvents.new(
        event_stream_id: @event_stream_id,
        from_event_number: from,
        max_count: 1096,
        resolve_link_tos: true,
        require_master: false
      )

    with {:ok, response} <- Extreme.execute(@server, read_events),
         %Extreme.Msg.ReadStreamEventsCompleted{events: events} <- response do
      Enum.each(events, &print_event/1)
    end
  end

  @spec print_event(any) :: any
  def print_event(%Extreme.Msg.ResolvedIndexedEvent{event: event}), do: print_event_record(event)

  def print_event(%Extreme.Msg.ResolvedEvent{event: event}), do: print_event_record(event)

  def print_event(event), do: Logger.error("Don't know what to do with #{inspect(event)}!")

  def print_event_record(event_record) do
    with %Extreme.Msg.EventRecord{data: raw_data} <- event_record do
      Logger.debug("raw_data => #{inspect(raw_data)}")

      with {:ok, data} <- Msgpax.unpack([raw_data]) do
        Logger.debug("data => #{inspect(data)}")

        with %{"who" => who} <- data do
          Logger.info(~s[Hello, "#{who}"!])
        end
      else
        err -> Logger.error(err)
      end
    end
  end
end
