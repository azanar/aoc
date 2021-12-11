use Jason

IO.puts "foo!"

case IO.read(:all) do
  {:error, reason} -> IO.puts "Could not read: #{reason}"
  data -> data
end |> Jason.decode!
