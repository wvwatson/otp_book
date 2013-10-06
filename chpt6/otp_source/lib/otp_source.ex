defmodule OtpSource do
  use Application.Behaviour

  @doc """
  The application callback used to start this
  application and its Dynamos.
  """
  def start(_type, _args) do
    OtpSource.Dynamo.start_link([max_restarts: 5, max_seconds: 5])
    OtpSource.ScStore.init
    case OtpSource.ScSup.start_link do
      {:ok, pid} ->
        {:ok, pid}
      other ->
        {:error, other}
    end 
  end
end
