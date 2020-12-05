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

seats = File.stream!("input.txt") |> Enum.map(&String.trim/1) |> Enum.map(&Seating.getID/1) |> Enum.sort
mySeat = Enum.reduce(seats, [], fn(element, acc) ->
    case {Enum.member?(seats, element+1), Enum.member?(seats, element+2)} do
        {false, true} -> [ element+1 | acc ]
        _ -> acc
    end
end)
IO.inspect mySeat