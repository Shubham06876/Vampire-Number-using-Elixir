defmodule My_application do
  use Application
  Code.compiler_options(ignore_module_conflict: true)

  def start(_type, _args) do
    args = System.argv()
    {n1,_}= Integer.parse(hd(args))
    {n2,_}= Integer.parse(hd(tl(args)))
    Parent.start_link(n1,n2)
  end

end


defmodule Parent do
  use Supervisor

  def start_link(n1,n2) do
    n3=10000
    range_list = Enum.take_every(n1..n2, n3)
    #IO.inspect(range_list)
    lists = for x <- range_list,do: [
      cond do
        x == n2->[x,x+1]
        n1<=n3 and n2<=n3->[n1,n2+1]
        x+(n3-1)>n2->[x,n2+1]
        true->[x,x+n3-1]
      end
    ]
    #lists = [[100000, 200000]]
    #IO.inspect(lists)
    init(lists)
    end

    def init(lists) do
       child = [worker(Get_vampire_numbers,[], [restart: :transient])]
       {:ok, _pid1} = Supervisor.start_link(child, strategy: :one_for_one)

       temp_lst = []
       temp_lst = for element <- lists do
        #IO.inspect(element)
        [n1,n2] = List.flatten(element)
        #IO.puts("#{n1} ----- #{n2}")
         vnchild = [worker(Vampirenumber,[], [id: n1*n2 + n1, restart: :transient])]
         #IO.inspect(vnchild)
         {:ok, pid} = Supervisor.start_link(vnchild, strategy: :one_for_one)
         [{_, temp_pid,_,_}] = Supervisor.which_children(pid)
         GenServer.cast(temp_pid, {:vampirenbr, n1, n2})
         temp_lst = temp_lst ++ [temp_pid]
         temp_lst
       end
       
        temp_lst = List.flatten(temp_lst)
        #IO.inspect(temp_lst)
        #IO.inspect(Process.alive?(hd(temp_lst)))
        n1=1
        n2=100000
        
        
        try do
          for _n <- n1..n2 do
          
            :timer.sleep(40)
            #Enum.all?(temp_lst, fn x -> IO.inspect(Process.alive?(x)) end)
           if Enum.all?(temp_lst, fn x -> Process.alive?(x) == false end) do
              throw(:break)
           end
          end
          catch
            :break ->
            list221 = Get_vampire_numbers.get_messages()
            get_output(list221, %{})
        end
              

    end


      # children = Enum.map(lists, fn([[n1,n2]]) ->
      #   worker(Vampirenumber,[], [id: n1*n2 + n1, restart: :transient])
      # end)

      # #IO.inspect(children)
      # {:ok, pid} = Supervisor.start_link(children, strategy: :one_for_one)
      # temp_pid_list = Supervisor.which_children(pid)
      
      # send_range(temp_pid_list, lists)
      #IO.inspect(:sys.get_status(pid))
      #IO.inspect(pid)
      #IO.inspect(Supervisor.count_children(pid))
      # IO.inspect(:sys.trace(pid, true))
     #  n1=1
     #  n2=100000

     #  try do
     #    for _n <- n1..n2 do
     #      :timer.sleep(40)
     #      #IO.inspect(:sys.get_status(pid))
     #      inspect_map = Supervisor.count_children(pid).active
     #      #IO.inspect(inspect_map)
     #      if inspect_map == 0 do
     #        throw(:break)
     #      end
     #    end
     #  catch
     #    :break ->
     #      list221 = Get_vampire_numbers.get_messages()
     #      get_output(list221, %{})
     #  end
     # end

    # def send_range(temp_pid_list, lists) do
    #   if length(lists)>0 do
    #     {_, temp_pid,_,_} = hd(temp_pid_list)
    #     #IO.inspect(temp_pid)
    #     [[n1,n2]] = hd(lists)
    #     #IO.inspect("#{n1}-----#{n2}")
    #     #IO.inspect(temp_pid)
    #     GenServer.cast(temp_pid, {:vampirenbr, n1, n2})
    #     #IO.inspect(lists)
        
    #     send_range(tl(temp_pid_list), tl(lists))
    #     end
    # end


    def get_output(list221, map1) do
      if length(list221)!=0 do
        ele = Enum.at(list221, 0)


        [str_v1, str_v2] = String.split(ele, " ")

          {v1,_} = Integer.parse(str_v1)
          {v2,_} = Integer.parse(str_v2)

        map1 = if Map.get(map1, v1*v2) != nil do
          Map.put(map1, v1*v2, Map.get(map1, v1*v2) <> " " <> str_v1 <> " " <> str_v2)
        else
          Map.put(map1, v1*v2, str_v1 <> " " <> str_v2)
        end
        get_output(tl(list221), map1)
      else
        for item <- Enum.sort(Map.keys(map1)) do
           IO.puts("#{item}" <> " " <> Map.get(map1, item))
        end
        #IO.inspect(length(Map.keys(map1)))
        send self(), {:ok, self()}
      end
      end
end

defmodule Vampirenumber do
  use GenServer

  def start_link() do
      GenServer.start_link(__MODULE__, [])
  end

  @impl true
  def init(state) do
    {:ok, state, 50}
  end
  
  @impl true
  def handle_cast({:vampirenbr, n1, n2}, state) do
    
    #IO.puts("#{n1}--------------#{n2}")
    find_number([n1,n2])
    {:noreply, :ok, state}
  end

  defp find_number(list1) do
    n1 = Enum.at(list1, 0)
    n2 = Enum.at(list1, 1)
    recursion(n1,n2)
  end


  defp recursion(x,y) do
    if x<y do
      str_x = Integer.to_string(x)
      if rem(String.length(str_x),2)==0 do
        factors(x,trunc(x / :math.pow(10, div(String.length(str_x),2))))
      end
      x=x+1
      recursion(x,y)
    end
  end

  defp factors(var, c) do
    if c<= :math.sqrt(var) |> round do
      loop(var,c)
      c = c+1
      factors(var, c)
    end
  end

  defp loop(var, c) do
    if rem(var, c) == 0 do
      var1 = c
      var2 = div(var, c)
      str_var1 = Integer.to_string(var1)
      str_var2 = Integer.to_string(var2)
      str_var  = Integer.to_string(var)
      if String.length(str_var1) == div(String.length(str_var),2) && String.length(str_var2) == div(String.length(str_var),2) && !(rem(var1,10)==0 && rem(var2,10)==0) do
        is_vampire(var, var1, var2)
      end
    end
  end

  defp is_vampire(completenbr, v1, v2) do
    str_c1 = Integer.to_string(completenbr)
    l_c1 = Enum.sort(String.graphemes(str_c1))
    str_c2 = Integer.to_string(v1) <> Integer.to_string(v2)
    l_c2 = Enum.sort(String.graphemes(str_c2))
    if l_c1 === l_c2 do
      o_str = Integer.to_string(v1) <> " " <> Integer.to_string(v2)
      #IO.puts("#{v1*v2}")
      Get_vampire_numbers.add_message(o_str)
      #IO.puts("is vampire ")

    end
  end

  # @impl true
  # def handle_call({:job_timeout,timeout},_from,state) do
  #   {:reply, :ok, state, timeout}
  # end
@impl true
def handle_info(:timeout, state) do
  {:stop, :normal, state}
end

end
# defmodule Vampirenumber do
#   use GenServer

#   def start_link(n1,n2) do
#     IO.puts("assal start")
#       GenServer.start_link(__MODULE__,[n1,n2] )
#   end

#   @impl true
#   def init(list1) do
#     IO.puts("init find numbert")
#     find_number(list1)
#     {:ok, list1, 1}
#   end

#   defp find_number(list1) do
#     n1 = Enum.at(list1, 0)
#     n2 = Enum.at(list1, 1)
#     recursion(n1,n2)
#   end


#   defp recursion(x,y) do
#     if x<y do
#       str_x = Integer.to_string(x)
#       if rem(String.length(str_x),2)==0 do
#         factors(x,trunc(x / :math.pow(10, div(String.length(str_x),2))))
#       end
#       x=x+1
#       recursion(x,y)
#     # else
#     #   GenServer.call(Vampirenumber, {:job_timeout, 500})
#     end
#   end

#   defp factors(var, c) do
#     if c<= :math.sqrt(var) |> round do
#       loop(var,c)
#       c = c+1
#       factors(var, c)
#     end
#   end

#   defp loop(var, c) do
#     if rem(var, c) == 0 do
#       var1 = c
#       var2 = div(var, c)
#       str_var1 = Integer.to_string(var1)
#       str_var2 = Integer.to_string(var2)
#       str_var  = Integer.to_string(var)
#       if String.length(str_var1) == div(String.length(str_var),2) && String.length(str_var2) == div(String.length(str_var),2) && !(rem(var1,10)==0 && rem(var2,10)==0) do
#         is_vampire(var, var1, var2)
#       end
#     end
#   end

#   defp is_vampire(completenbr, v1, v2) do

#     str_c1 = Integer.to_string(completenbr)
#     l_c1 = Enum.sort(String.graphemes(str_c1))
#     str_c2 = Integer.to_string(v1) <> Integer.to_string(v2)
#     l_c2 = Enum.sort(String.graphemes(str_c2))
#     if l_c1 === l_c2 do
#       o_str = Integer.to_string(v1) <> " " <> Integer.to_string(v2)
#       IO.puts("is vampire")
#       #IO.puts("#{v1*v2} ka jamaude hai #{v1} aur #{v2} sath")
#       Get_vampire_numbers.add_message(o_str)
#     end
#   end

#   # @impl true
#   # def handle_call({:job_timeout,timeout},_from,state) do
#   #   {:reply, :ok, state, timeout}
#   # end
# @impl true
# def handle_info(:timeout, state) do
#   IO.puts("handle info")
#   {:stop, :normal, state}
# end

# end

defmodule Get_vampire_numbers do
  use GenServer

  def start_link do
      GenServer.start_link(__MODULE__, [], name: :get_vampire_number)
  end

  def init(init_arg) do
      {:ok, init_arg}
  end

  def add_message(o_str) do
    GenServer.cast(:get_vampire_number, {:add_message, o_str})
  end

  def get_messages do
    GenServer.call(:get_vampire_number, :get_messages)
  end

  def handle_cast({:add_message, new_message}, messages) do
    #IO.puts(Enum.reduce(String.split(new_message, " ", trim: true),1,fn x,acc ->String.to_integer(x)*acc end))
    {:noreply, [new_message | messages]}
  end

  def handle_call(:get_messages, _from, messages) do
    {:reply, messages, messages}
  end
end