# Streamer

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `lightning_talk_eu_2017` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:lightning_talk_eu_2017, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/lightning_talk_eu_2017](https://hexdocs.pm/lightning_talk_eu_2017).

```elixir
proc = Porcelain.shell("""ffmpeg -y -i - -b:a 128k -b:v 2500k -minrate 2500k -maxrate 2500k -bufsize 5000k -c copy -f flv rtmp://live.twitch.tv/app/$STREAM_KEY", opts)
```
