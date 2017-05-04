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

defmodule StreamRunner do
  def run() do
    {:ok, _} = StreamRunner.Playlist.start_link
    stream = Stream.repeatedly(&get_next_video/0)
    |> Stream.take(4)
    |> Stream.concat
    opts = [in: stream]
    Porcelain.shell("ffmpeg -y -i - output.ts", opts)
    GenServer.stop(StreamRunner.Playlist)
    Porcelain.shell("open output.ts")
  end

  def get_next_video() do
    file = case StreamRunner.Playlist.pop do
      nil ->
        StreamRunner.Playlist.push("bunny.ts")
        "brb.ts"
      file -> file
    end
    IO.inspect({"getting video", file})
    File.stream!(file, [], 1024) |> Stream.take(4096)
  end
end
