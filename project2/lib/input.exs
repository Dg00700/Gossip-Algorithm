defmodule Project2 do
  # Parse input arguments
  def main do
    [node,topology,algorithm]=System.argv()

        case algorithm do
          "gossip" ->
            Gossip.Algorithm.init_rumor(
              topology,
              String.to_integer(node)
             )
            "pushsum" ->
              Gossip.Algorithm.init_pushsum(
                topology,
                String.to_integer(node)
              )
          _ ->
            IO.puts("Invalid algorithm")
            IO.puts("Enter gossip or push-sum")
            System.halt(0)
        end
      end
    
  end

Project2.main()