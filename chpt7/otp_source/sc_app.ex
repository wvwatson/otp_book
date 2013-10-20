defmodule OtpSource.ScApp do
  use Application.Behaviour

  def start(_starttype, _startargs) do
    OtpSource.ScStore.init
    case OtpSource.ScSup.start_link do
      {:ok, pid} ->
        {:ok, pid}
      other ->
        {:error, other}
    end 
  end

  def stop(_state) do
    :ok
  end
  
end
