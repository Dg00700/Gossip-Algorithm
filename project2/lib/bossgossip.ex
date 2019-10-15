defmodule Boss.Gossip do
    use GenServer
    def start_link(node, neighbours) do
      GenServer.start_link(__MODULE__, [node, neighbours],  name: String.to_atom(Integer.to_string(node)))
    end
  
    def init_gossip(neighbours, message) do
     
      peer = Process.whereis(String.to_atom(Integer.to_string(Enum.random(neighbours))))
  
      if peer != nil do
        send(peer, {:infect, message})
        send(peer, {:count, []})
      end
  
      init_gossip(neighbours, message)
    end
  
    
    def init([node, neighbours]) do
      receive do
        {:infect, message} ->
          Task.start(fn -> init_gossip(neighbours, message) end)
          counter(1)
      end
  
      {:ok, node}
    end
  
    def counter(count) do
      if(count < 10) do
        receive do
          {:count, _} -> counter(count + 1)
        end
      else
        send(Process.whereis(:supervisor), {:converged, self()})
        Process.exit(self(), :normal)
      end
    end
  end