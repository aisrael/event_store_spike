# event_store_spike

This is an example Elixir project that demonstrates EventStore and the [Extreme]

### Prerequisites

- Docker & `docker-compose`
- Elixir 1.9.x

### Usage

First, run EventStore (using Docker):

```
$ docker-compose up -d
```

Next, start the application using `iex`:

```
$ iex -S mix
```

That automatically starts the `Hello.Subscriber` listening on the `hello` events stream.

#### To send a message

```
iex> Hello.hello("test one")
```

#### To read previous messages (from a given offset)

```
iex> Hello.read_events(0)
```

### See it in action:

[![asciicast](https://asciinema.org/a/05hIxwCzJdVD5OoNo8YTr14zS.svg)](https://asciinema.org/a/05hIxwCzJdVD5OoNo8YTr14zS)
