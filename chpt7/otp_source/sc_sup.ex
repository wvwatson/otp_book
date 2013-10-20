defmodule OtpSource.ScSup do
  Supervisor.Behavior

  @server __MODULE__

  def start_link do
    :supervisor.start_link({:local, @server}, __MODULE__, [])
  end

  def init do

    elementsup = {OtpSource.ScElement, {OtpSource.ScElement, start_link, []}, :permanent, 2000, :supervisor, [OtpSource.ScElement]}

    eventmanager = {:sc_event, {OtpSource.ScEvent, start_link, []}, Permanent, 2000, :worker, [:sc_evet]}

    children = [elementsup, eventmanager]

    restartstrategy = {:one_for_one, 4, 3600} 
    {:ok, {restartstrategy, children}}  
  end
end
