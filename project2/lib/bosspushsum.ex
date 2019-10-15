defmodule Boss.PushSum do
    use GenServer
  
   
    def start_link(node, neighbours) do
      GenServer.start_link(__MODULE__, [node, neighbours],  name: String.to_atom(Integer.to_string(node)))
    end
     def init([node, neighbours]) do
      receive do
        {:infect, s, w} ->
          task =
            Task.start(fn ->
              init_pushsum(node, neighbours)
            end)
  
          counter(3, s + node, w + 1, node, elem(task,1))
      end
  
      {:ok, node}
    end
  
    def init_pushsum(node, neighbours) do
      {s, w} =
        receive do
          {:send, s_receive, w_receive} -> {s_receive, w_receive}
        end
  
      index = :rand.uniform(length(neighbours)) - 1
      peer = Process.whereis(String.to_atom(Integer.to_string(Enum.at(neighbours, index))))
  
      if peer != nil do
        send(peer, {:infect, s, w})
      end
  
      init_pushsum(node, neighbours)
    end
  
    def counter(count, s, w, ratio, parent) do
      curr_ratio = s / w
      diff = abs(curr_ratio - ratio)
      count = check_tick(diff, count)
  
      if count < 1 do
        send(Process.whereis(:supervisor), {:converged, self()})
        Process.exit(self(), :normal)
      else
        s_half = s / 2
        w_half = w / 2
        send(parent, {:send, s_half, w_half})
        listener(count, s_half, w_half, curr_ratio, parent)
      end
    end
  
    def listener(count, s, w, curr_ratio, parent) do
      receive do
        {:infect, s_receive, w_receive} ->
          counter(count, s_receive + s, w_receive + w, curr_ratio, parent)
      after
        300 -> counter(count, s, w, curr_ratio, parent)
      end
    end
  
    def check_tick(diff, curr_count) do
      cond do
        diff > :math.pow(10, -10) ->
          3
  
        true ->
          curr_count - 1
      end
    end
  end