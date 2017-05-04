class: middle, center
# Elixir Streams and Video
### John Wahba
---
class: middle, center
.center[![](/Users/jwahba/workspace/src/code.justin.tv/jwahba/lightning_talk_eu_2017/logo.png)]
---
class: middle, left
# What I used to do
- Decide which video to stream from S3 (Ruby)
- Stream videos from S3 to Twitch (Golang)
---
class: middle, left
# What I do now
- Decide which video to stream from S3 (Elixir)
- Stream videos from S3 to Twitch (Elixir)
---
class: middle, left
# Challenges
- Can't just "load it all into memory"
  - Videos often > 10 GB
- Can't know everything that will play ahead of time
  - Some videos don't exist yet
- Don't go down
  - Dead air is bad
---
class: left, middle
# Playlist
```elixir
defmodule StreamRunner.Playlist do
  def start_link() do
    Agent.start_link(fn -> ["bunny.ts"] end, name: __MODULE__)
  end

  def push(file) do
    Agent.update(__MODULE__, fn(queue) -> queue ++ [file] end)
  end

  def pop() do
    Agent.get_and_update(__MODULE__, &do_pop/1)
  end

  defp do_pop([]), do: {nil, []}
  defp do_pop([h|t]), do: {h, t}
end
```
---
class: left, middle
# StreamRunner
```elixir
defmodule StreamRunner do
  def run() do
    {:ok, _} = StreamRunner.Playlist.start_link
    stream = Stream.repeatedly(&get_next_video/0)
    |> Stream.take(4)
    |> Stream.concat
    Porcelain.shell("ffmpeg -y -i - output.ts", [in: stream])
    Porcelain.shell("open output.ts")
  end
  def get_next_video() do
    file = case StreamRunner.Playlist.pop do
      nil ->
        StreamRunner.Playlist.push("bunny.ts")
        "brb.ts"
      file -> file
    end
    File.stream!(file, [], 1024)
    |> Stream.take(4096)
  end
end
```
---
class: middle, center
# Demo
---
class: middle, center
# How to stream to twitch
```elixir
proc = Porcelain.shell("ffmpeg -y -i - -b:a 128k -b:v 2500k \
-minrate 2500k -maxrate 2500k -bufsize 5000k -c copy -f flv \
rtmp://live.twitch.tv/app/$STREAM_KEY", opts)
```
---
class: middle
# # TODO:
- Switch from local files to signed S3 urls using HTTPoison
- Use GenStage.BroadcastDispatcher to support multiple streams at once
---
class: center, middle
# Thanks!
- https://github.com/johnwahba
