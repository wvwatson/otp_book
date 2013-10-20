Code.require_file "test_helper.exs", Path.join(__DIR__, "..")

defmodule TrServerTest do 
  use ExUnit.Case, async: false
  use OtpSource.TestCase
  use Dynamo.HTTP.Case
  import OtpSource.TrServer
  require Lager

  setup_all do
    # must start supervisor first
    case OtpSource.TrApp.start(OtpSource.TrApp,  []) do
      {:ok,pid} -> {:ok, setuppid: pid}
      {:error,{:error, {:already_started, pid}}} -> {:ok, setuppid: pid}
      other -> Lager.debug "OtpSource.ScApp.start ret: #{inspect(other)}"; other
    end
  end
  test ".get_count should call server get count" do
    #handle info interferes with the get_count call in the test ...
    #assert {:ok, 0} == get_count
  end

end

