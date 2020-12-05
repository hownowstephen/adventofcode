IO.puts("Hello, December 5th")

defmodule Seating do
    def getSeat(input) do
        {r, c} = Enum.split(String.graphemes(input), 7)
        row = Enum.reduce(r, %{:s=>0, :e=>127}, &Seating.reducer/2)
        col = Enum.reduce(c, %{:s=>0, :e=>7}, &Seating.reducer/2)
        {row.s, col.s}
    end

    def seatID(row, col) do
        row*8+col
    end

    def reducer("F", %{:s=>s, :e=>e}), do: %{s: s, e: floor(s + (e-s)/2)}
    def reducer("L", %{:s=>s, :e=>e}), do: %{s: s, e: floor(s + (e-s)/2)}
    def reducer("B", %{:s=>s, :e=>e}), do: %{s: floor(s + (e-s)/2)+1, e: e}
    def reducer("R", %{:s=>s, :e=>e}), do: %{s: floor(s + (e-s)/2)+1, e: e}
end

seats = File.stream!("input.txt") |> Enum.map(&String.trim/1) |> Enum.map(&Seating.getSeat/1)

seatmap = Enum.reduce(seats, %{}, fn({r,c}, acc) ->
    case Map.get(acc, r) do
        nil -> Map.merge(acc, %{r => [c]})
        _ -> %{acc | r => Enum.sort([c | acc[r]])}
    end
end)

fullRow = MapSet.new([0, 1, 2, 3, 4, 5, 6, 7])

Enum.reduce(seatmap, [], fn ({row, cols}, acc) -> 
    case {row, cols} do
        {_, [0, 1, 2, 3, 4, 5, 6, 7]} -> acc
        _ -> [row | acc]
    end
end) |> Enum.map(fn(value) ->
    m =MapSet.new(Map.get(seatmap, value))
    d = MapSet.difference(fullRow, m)
    IO.inspect d
end)