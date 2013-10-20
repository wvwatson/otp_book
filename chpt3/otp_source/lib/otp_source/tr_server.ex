defmodule OtpSource.TrServer do
  use GenServer.Behaviour
  require Lager

  @default_port 1055
  @server __MODULE__

  defrecord State, port: nil, lsock: nil, request_count: 0

  def start_link(port) do
    Lager.info "start_link 1"
    IO.puts "Hello World"
    :gen_server.start_link({:local, @server}, __MODULE__, [port], [])
  end

  def start_link do
    Lager.debug "start_link 0"
    start_link(@default_port)
  end


  def stop() do
    :gen_server.cast(@server, :stop)
  end

  def init([port] // [1055]) do
    Lager.compile_log_level(:info)
    Lager.error "Hi debug"
    if not is_integer(port) do
     port = 1055
    end 
    :lager.start
    Lager.error "port: #{port}"
    {:ok, lsock} = :gen_tcp.listen(port, [{:active, true}])
    {:ok, State[port: port, lsock: lsock], 0}
  end

  def get_count do
    :gen_server.call(@server, :get_count)
  end

  def handle_call(:get_count, _from, state) do
    Lager.error "handle_call :get_count"
    {:reply, {:ok, state.request_count}, state}
  end

  def handle_cast(:stop, state) do
    {:stop, :normal, state}
  end

  def handle_info({:tcp, socket, raw_data}, state) do
    Lager.info "handle_info tuple, state"
    Lager.info "raw_data: #{inspect(raw_data)}"
    do_rpc(socket, raw_data)
    {:noreply, state.update(request_count: (state.request_count + 1))}
  end

  def handle_info(:timeout, State[lsock: lSock] = state) do
    Lager.info "handle_info timeout, state pattern"
    {:ok, _Sock} = :gen_tcp.accept(lSock)
    {:noreply, state}
  end

  def terminate(_reason, _state) do
    :ok
  end

  def code_change(_old_vsn, state, _extra) do
    {:ok, state}
  end 

  def do_rpc(socket, raw_data) do
    Lager.info "do_rcp/2"
    try do
      {m, f, a} = split_out_mfa(raw_data)
      #m = :module
      #f = :function
      #a = [:arg1, :arg2]
      Lager.info "do_rpc mfa"
      Lager.info "m: #{m}"
      Lager.info "f: #{f}"
      Lager.info "a: #{a}"
      result = apply(m, f, a)
      :gen_tcp.send(socket, :io_lib.fwrite("~p~n", [result]))
    rescue
      x in [RunTimeError] ->
        :gen_tcp.send(socket, :io_lib.fwrite("~p~n", [x.message]))
    end
  end

  def split_out_mfa(raw_data) do
    Lager.info "split_out_mfa/1"
    Lager.info "raw_data #{raw_data}"
    mfa = :re.replace(raw_data, "\r\n$", "", [{:return, :list}])
    #mfa = Regex.replace(raw_data, "\r\n$", "", [{:return, :list}])
    #{:match, [m, f, a]} = :re.run([mfa], "(.*):(.*)\s*\\((.*)\s*\\)\s*.\s*$", [{:capture, [1,2,3], :list}, :ungreedy])
    {:match, [m, f, a]} = :re.run([mfa], "([^:]*):([^(]*)\s*\\((.*)\s*\\)\s*.\s*$", [{:capture, [1,2,3], :list}])
    #{list_to_atom(m), list_to_atom(f), args_to_terms(a)}
    matom = list_to_atom(m)
    fatom = list_to_atom(f)
    Lager.info "matom #{matom}"
    Lager.info "fatom #{fatom}"
    Lager.info "original a: #{a}"
    #{matom, fatom, []}
    {matom, fatom, args_to_terms(a)}
  end

  def args_to_terms(raw_args) do
    Lager.info "args_to_terms/1"
    Lager.info "raw_args: #{raw_args}"
    {:ok, toks, _line} = :erl_scan.string('[' ++ to_char_list(raw_args) ++ ']. ', 1)
    {:ok, args} = :erl_parse.parse_term(toks)
    #args = []
    args
  end
  

end

