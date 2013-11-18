defmodule OtpSource.ScElement do
  use GenServer.Behaviour
  #import OtpSource.ScSup
  require Lager

  @server __MODULE__
  @default_lease_time (60 * 60 * 24)

  defrecord State, value: nil, lease_time: nil, start_time: nil

  def start_link(value, leasetime) do
    Lager.debug "#{inspect(__MODULE__)}.start_link"
    :gen_server.start_link(__MODULE__, [value, leasetime], [])
  end

  @doc """
    Takes a list which contains a value a starting lease
  """
  def init([value, lease_time]) do
    now = :calendar.local_time
    start_time = :calendar.datetime_to_gregorian_seconds(now)
    {:ok, State[value: value,  
                lease_time: lease_time,
                start_time: start_time], 
      time_left(start_time, lease_time)}
  end

  @doc """
    Creates a new sc element process that has a value that will last the length
    of the lease time 
  """
  def create(value, leasetime) do
    OtpSource.ScElementSup.start_child(value, leasetime)
  end
     
  def create(value) do
    create(value, @default_lease_time)
  end



  def time_left(_start_time, :infinity) do
    :infinity
  end

  def time_left(start_time, lease_time) do
    now = :calendar.local_time
    current_time = :calendar.datetime_to_gregorian_seconds(now)
    time_elapsed = current_time - start_time
    case lease_time - time_elapsed do
      time when time <= 0 -> 0
      time -> time * 1000
    end
  end

  @doc """
    API for fetch functionality 
  """
  def fetch(pid) do
    :gen_server.call(pid, :fetch)
  end

  @doc """
    Callback (call) from OTP to handle fetch functionality.  Returns state 
    after updating time left. Matches on function name, calling pid, and param(state)
  """
  def handle_call(:fetch, _from, state) do
    State[value: value, lease_time: lease_time, start_time: start_time] = state
    timeleft = time_left(start_time, lease_time)
    {:reply, {:ok, value}, state, timeleft}
  end

  @doc """
    API for replace functionality 
  """
  def replace(pid, value) do
    :gen_server.cast(pid, {:replace, value})
  end

  @doc """
    Callback (cast)from OTP to handle replace functionality. Replaces the value 
    in the passed process.  Matches on a tuple of the function name and params 
    as first arg.
  """
  def handle_cast({:replace, value}, state) do
    State[lease_time: lease_time, start_time: start_time] = state
    timeleft = time_left(start_time, lease_time)
    {:noreply, state.update(value: value), timeleft}
  end

  @doc """
    API for delete functionality 
  """
  def delete(pid) do
    :gen_server.cast(pid, :delete)
  end

  @doc """
    Callback (cast)from OTP to handle delete functionality. Destroys the passed process
    and the value it contains.  Matches on function name.
  """
  def handle_cast(:delete, state) do
    Lager.debug "entered into delete handle_cast"
    {:stop, :normal, state}
  end

  def handle_info(timeout, state) do
    {:stop, :normal, state}
  end

  def terminate(_reason, _state) do
    # call sc store delete when it exists
    :ok
  end

  def code_change(_oldvsn, state, _extra) do
    {:ok, state}
  end
end
