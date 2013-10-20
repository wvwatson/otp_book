defmodule OtpSource.TrSup do
  use Supervisor.Behaviour

  @server __MODULE__
  
  def start_link do
    :supervisor.start_link({:local, @server}, __MODULE__, [])
  end

  def init([]) do
    server = {OtpSource.TrServer, {OtpSource.TrServer, :start_link, []},
    :permanent, 2000, :worker, [OtpSource.TrServer]}
    children = [server]
    restart_strategy = {:one_for_one, 0, 1}
    {:ok, {restart_strategy, children}}
  end
end
