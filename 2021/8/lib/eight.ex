defmodule Eight do
  @moduledoc """
  Documentation for `Eight`.
  """

  @doc """
  Hello world.

  ## Examples

  iex> Eight.hello()
  :world

  """
  def hello do
    :world
  end
end

defmodule Eight.CLI do
  def main(args \\ []) do
    case IO.read(:all) do
      {:error, reason} -> IO.puts "Could not read: #{reason}"
      data -> data
    end |> Jason.decode!
    |> Enum.map(fn x ->
      case x do
        [patterns, output] -> patterns |> sets |> analyze
        _ -> 0
      end
    end) |> IO.inspect
  end

  defp sets(patterns) do
    patterns 
    |> Enum.map(fn p -> p
    |> String.split("", trim: true) 
    |> MapSet.new
    end)
  end

  defp analyze(patterns) do
    segments = %{}

    known = patterns
            |> Enum.map(fn e ->
              case MapSet.size(e) do
                2 -> 1
                3 -> 7
                4 -> 4
                7 -> 8
                _ -> nil
              end |> case do
                nil -> nil
                x -> {x, e}
              end
            end)
            |> Enum.reject(&Kernel.is_nil/1)
            |> Map.new

    a = MapSet.difference(Map.fetch!(known, 7), Map.fetch!(known, 1)) |> MapSet.to_list |> case do
      [] -> raise "No top segment found"
      [code] -> code
      [ _ | _ ] -> raise "Multiple top segments found"
    end

    segments = Map.put(segments, :a, a)

    mask = Map.fetch!(known, 4) |> MapSet.put(a)

    eg_list = patterns 
                                    |> Enum.map(fn p -> MapSet.difference(p, mask) end) 
                                    |> Enum.filter(fn s -> MapSet.size(s) > 0 end) 
                                    |> Enum.uniq

    g_set = eg_list
                 |> Enum.filter(fn s -> MapSet.size(s) == 1 end) 
                 |> List.first

    g = g_set 
             |> MapSet.to_list 
             |> List.first

    eg = eg_list
          |> List.delete(g_set) 
          |> List.first

    e = bottom_lower_left 
                 |> MapSet.delete(g)
                 |> MapSet.to_list 
                 |> List.first

    segments = segments |> Map.merge(%{e: e, g: g})

    acefg = Map.fetch!(known, 1) |> MapSet.union(MapSet.new([a,e,g]))

    left = patterns 
           |> Enum.map(fn p -> MapSet.difference(p, mask) end) 
           |> Enum.filter(fn s -> MapSet.size(s) > 0 end) 
           |> Enum.uniq

    left |> IO.inspect

    segments

  end
end
