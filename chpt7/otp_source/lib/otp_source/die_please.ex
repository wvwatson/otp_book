defmodule OtpSource.DiePlease do
  GenServer.Behaviour

  @server  __MODULE__
  @sleep_time (2*1000)

  defrecord State, name: nil
end
