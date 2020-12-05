IO.puts("Hello, December 5th")

defmodule Seating do
    def getID(input) do
        {r, c} = Enum.split(String.graphemes(input), 7)
        row = Enum.reduce(r, %{:s=>0, :e=>127}, &Seating.reducer/2)
        col = Enum.reduce(c, %{:s=>0, :e=>7}, &Seating.reducer/2)
        row.s*8+col.s
    end

    def reducer("F", %{:s=>s, :e=>e}), do: %{s: s, e: floor(s + (e-s)/2)}
    def reducer("L", %{:s=>s, :e=>e}), do: %{s: s, e: floor(s + (e-s)/2)}
    def reducer("B", %{:s=>s, :e=>e}), do: %{s: floor(s + (e-s)/2)+1, e: e}
    def reducer("R", %{:s=>s, :e=>e}), do: %{s: floor(s + (e-s)/2)+1, e: e}
end

stream = File.stream!("input.txt")
lines = Enum.map(stream, &String.trim/1)
IO.puts(Enum.max(Enum.map(lines, &Seating.getID/1)))