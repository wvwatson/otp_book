defmodule OtpSource.TrApp do
  use Application.Behaviour
  require Lager

  def start(type, start_args) do
    Lager.debug "#{base} -> #{test}: Checking for trade"
    case OtpSource.TrSup.start_link do
      {:ok, pid} -> {:ok, pid}
      other -> {:error, other}
    end
  end

  def stop(_state) do
    :ok
  end

end


