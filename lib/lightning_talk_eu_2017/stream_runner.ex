defmodule StreamRunner do
  def run() do
    stream = File.stream!("bunny.ts", [], 2048)
    |> Stream.cycle
    |> Stream.take(10_000)

    stream = Stream.concat(stream, stream)
    |> Stream.concat(stream)

    opts = [in: stream, err: :out, out: IO.stream(:stderr, :line)]
    proc = Porcelain.shell("ffmpeg -y -i - output.ts", opts)
  end
end
