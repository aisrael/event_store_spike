use Mix.Config

config :extreme, :event_store,
  db_type: :node,
  host: "localhost",
  port: 1113,
  username: "admin",
  password: "changeit",
  reconnect_delay: 2_000,
  connection_name: :my_app,
  max_attempts: :infinity

# Configures Elixir's Logger
elixir_logger_level = System.get_env("ELIXIR_LOGGER_LEVEL", "info")

level =
  %{
    "1" => :debug,
    "2" => :info,
    "3" => :warn,
    "debug" => :debug,
    "info" => :info,
    "warn" => :warn
  }
  |> Map.get(String.downcase(elixir_logger_level), :debug)

config :logger, :console,
  level: level,
  format: "$time [$level] $levelpad$metadata $message\n",
  metadata: [:pid]
