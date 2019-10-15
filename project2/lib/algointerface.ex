defmodule Gossip.Algorithm do

#...................................PUSHSUM..........................................................#
    def init_pushsum(topology_choosen,num) do
        topology =
        case topology_choosen do
          "full" ->
           
            Gossip.Topology.full(Enum.to_list(1..num))
  
          "line" ->
            Gossip.Topology.line(Enum.to_list(1..num))
  
            "rand_2d" ->
             Gossip.Topology.rand_2d_grid(Enum.to_list(1..num))
             "honeycomb" ->
               Gossip.Topology.honeycomb(num)
         "honeycombrandom" ->
                Gossip.Topology.honeycombrand(num)
            "3dtorus" ->
                Gossip.Topology.get_3d_torus(num)
            
            true ->
            IO.puts("Selected topology not found")
            System.halt()
        end
        len = length(topology)
        # Spawn 
        for i <- 1..len do
            neighbours = Enum.at(topology, i - 1)
  
            spawn(fn ->
            Boss.PushSum.start_link(i, neighbours)
            end)
        end
  
     
      tracker = Task.async(fn -> tracker(len) end)
  
     
      Process.register(tracker.pid, :supervisor)
      start = System.monotonic_time(unquote(:millisecond))
  
     
      pushsum_init(len)
      Task.await(tracker, len * 5000)
      time_spent = System.monotonic_time(unquote(:millisecond)) - start
      IO.puts("Convergance time: #{time_spent}ms")
    end
  
    def pushsum_init(len) do
      init_node = Process.whereis(String.to_atom(Integer.to_string(Enum.random(1..len))))
  
        if Process.alive?(init_node) do
            send(init_node, {:infect, 0, 0})
        end
    end
  #.............................................GOSSIP............................................................#
    def init_rumor( topology_choosen,num) do
        topology =
        case topology_choosen do
          "full" ->
          Gossip.Topology.full(Enum.to_list(1..num))
  
          "line" ->
            Gossip.Topology.line(Enum.to_list(1..num))
  
         "rand_2d" ->
            Gossip.Topology.rand_2d_grid(Enum.to_list(1..num))
            
         "honeycomb" ->
            Gossip.Topology.honeycomb(num)
        "honeycombrandom" ->
            Gossip.Topology.honeycombrand(num)
            "3dtorus" ->
                Gossip.Topology.get_3d_torus(num)
            
            true ->
            System.halt()
        end
        
        len = length(topology)
  
      # Spawn 
      for i <- 1..len do
        neighbours = Enum.at(topology, i - 1)
  
        spawn(fn ->
          Boss.Gossip.start_link(i, neighbours)
        end)
      end
  
     
      tracker = Task.async(fn -> tracker(len) end)
  
      
      Process.register(tracker.pid, :supervisor)
      start = System.monotonic_time(unquote(:millisecond))
  
     
      gossip_init(len)
      Task.await(tracker, len * 5000)
      time_spent = System.monotonic_time(unquote(:millisecond)) - start
      IO.puts("Convergance Time #{time_spent}")
    end
  
    def gossip_init(len) do
      init_node = Process.whereis(String.to_atom(Integer.to_string(Enum.random(1..len))))
  
        if    Process.alive?(init_node) do
            send(init_node, {:infect, "You've been infected."})
        end
    end
    def tracker(len) do
        cond do
            len > 0 ->
            receive do
                {:converged, _pid} ->
                
                tracker(len - 1)
                after
                3500 ->
                
                tracker(len - 1)
            end
  
            true ->
            nil
        end
    end
end