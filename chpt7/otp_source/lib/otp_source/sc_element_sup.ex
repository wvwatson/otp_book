defmodule OtpSource.ScElementSup do
  use Supervisor.Behaviour
  require Lager
  @server __MODULE__

  def server_name do
    @server
  end

  @doc """ 
    creates a supervisor with a simple one for one strategy
  """
  def init([]) do
    element = {OtpSource.ScElement, {OtpSource.ScElement, :start_link, []},
              :temporary, :brutal_kill, :worker, [OtpSource.ScElement]}
    children = [element]
    restart_strategy = {:simple_one_for_one, 0, 1}
    # otp uses this return value ... cant test it
    {:ok, {restart_strategy, children}}
  end

  def start_link do
    :supervisor.start_link({:local, @server}, __MODULE__, [])
  end

  def start_child(value, leasetime) do
    :supervisor.start_child(@server, [value, leasetime])
  end

end
