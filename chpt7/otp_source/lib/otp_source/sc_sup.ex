defmodule OtpSource.ScSup do
  use Supervisor.Behaviour
  require Lager
  @server __MODULE__

  def server_name do
    @server
  end

  def init([]) do
    element_sup = {OtpSource.ScElementSup, {OtpSource.ScElementSup, :start_link, []},
                  :permanent, 2000, :supervisor, [OtpSource.ScElement]}

    event_manager = {OtpSource.ScEvent, {OtpSource.ScEvent, :start_link, []},
                  :permanent, 2000, :worker, [OtpSource.ScEvent]}

    children = [element_sup, event_manager]

    restart_strategy = {:one_for_one, 4, 3600}

    {:ok, {restart_strategy, children}}
  end

  def start_link do
    :supervisor.start_link({:local, @server}, __MODULE__, [])
  end
end
