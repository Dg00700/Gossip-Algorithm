defmodule Gossip.Topology do
    #................................................FULL........................................#
      def full(nodes_list) do
          Enum.map(nodes_list, fn node ->
            nodes = Enum.to_list(nodes_list)
            List.delete(nodes, node)
          end)
      end
    #................................................LINE..........................................#
      def line(nodes_list) do
            Enum.map(nodes_list, fn x ->
              cond do
                x == 1 -> [x + 1]
                x == length(nodes_list) -> [x - 1]
                true -> [x + 1, x - 1]
              end
            end)
      end
    #...............................................2DGRID............................................#
      def rand_2d_grid(nodes_list) do
        nodes_location = Enum.map(nodes_list, fn _ -> [:rand.uniform(), :rand.uniform()] end)
    
        distance_map =
          Enum.map(nodes_location, fn location ->
            x = Enum.at(location, 0)
            y = Enum.at(location, 1)
    
            Enum.map(nodes_location, fn nodes ->
              x1 = :math.pow(x - Enum.at(nodes, 0), 2)
              x2 = :math.pow(y - Enum.at(nodes, 1), 2)
              :math.sqrt(x1 + x2)
            end)
          end)
    
        res =
          Enum.map(distance_map, fn peers ->
            Enum.filter(1..(length(peers)), fn x ->
              Enum.at(peers, x) < 0.1 && Enum.at(peers, x) != 0
            end)
          end)
    
        Enum.map(res, fn adjnodes ->
          if length(adjnodes) == 0 do
            IO.puts("Multiple connected network created. Exiting.")
            System.halt()
          end
        end)
    
        res
    
      end
    #.....................................................Honeycomb..............................................#  
    def honeycomb(nodes) do
        
        k=nodes/20
        numNodes=Float.ceil(k)*18
        numNodes=trunc(numNodes)
        n = Enum.map(1..numNodes, fn x->
            peer2=if(rem(x,9)!=1)do x-1 end
            peer1=if(rem(x,9)!=0 && x+1<=numNodes) do x+1 end 
            peer3=if(rem(x,2)!=0 && x+7<=numNodes)do x+9 else if (rem(x,2)==0 && x-9>0) do x-9 end end
            _list=[peer1,peer2,peer3]
            |>Enum.reject(&is_nil/1)
            |>Enum.map(fn x->
            x
            end)
    end)
    n
    end
    #............................................HoneycombRandom.................................................#
    def honeycombrand(nodes) do
        
        k=nodes/18
        numNodes=Float.ceil(k)*18
        numNodes=trunc(numNodes)
        n = Enum.map(1..numNodes, fn x->
            peer2=if(rem(x,9)!=1)do x-1 end
            peer1=if(rem(x,9)!=0 && x+1<=numNodes) do x+1 end 
            peer3=if(rem(x,2)!=0 && x+7<=numNodes)do x+9 else if (rem(x,2)==0 && x-9>0) do x-9 end end
            peer4= Enum.random(1..numNodes)
            _list=[peer1,peer2,peer3,peer4]
            |>Enum.reject(&is_nil/1)
            |>Enum.map(fn x->
            x
            end)
    end)
    n
    end
    #...........................................3D Torus...........................................................#
    def get_3d_torus(numNodes) do
            root=round(:math.pow(numNodes, 0.34))
            numNodes = root * root * root
            root=trunc(root)
            _my_list=Enum.map(1..numNodes,fn i ->
            cond1=cond do
                rem(i,root)==1->
                node1 = i+1
                node2 = i+ (root-1)
                Enum.uniq([node1,node2])
                rem(i,root)==0->
                node1 = i-1
                node2 = i - (root-1)
                Enum.uniq([node1,node2])
                rem(i,root)!=0 && rem(i,root)!=1->
                node1 = i-1
                node2 = i+1
                Enum.uniq([node1,node2])
            end
            cond2=cond do
                div(rem(i-1,root*root),root) == 0->
                node3 = i+root
                node4 = i + root*(root-1)
                Enum.uniq([node3,node4])
                div(rem(i-1,root*root),root) == (root-1)->
                node3 = i-root
                node4 = i - root*(root-1)
                Enum.uniq([node3,node4])
                div(rem(i-1,root*root),root)>0 && div(rem(i-1,root*root),root)<(root-1) ->
                node3 = i-root
                node4 = i+root
                Enum.uniq([node3,node4])
            end
           
            cond3= cond do
               div(i-1,(root*root)) == 0->
                 node5 = i + root*root
                 node6 = i + root*root*(root-1)
                Enum.uniq([node5,node6])
               div(i-1,(root*root)) == (root-1)->
                 node5 = i- root*root
                 node6 = i - root*root*(root-1)
                Enum.uniq([node5,node6])
               div(i-1,(root*root))>0 && div(i-1,(root*root))<(root-1)->
                 node5 = i-root*root
                 node6 = i+root*root
                Enum.uniq([node5,node6])
            end
              cond1++cond2++cond3
        end)
    end

end