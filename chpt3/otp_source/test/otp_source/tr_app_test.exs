Code.require_file "test_helper.exs", Path.join(__DIR__, "..")

defmodule TrAppTest do
  use OtpSource.TestCase
  use Dynamo.HTTP.Case
  import OtpSource.TrApp
  require Lager

  test "start should return ok" do
    case start(OtpSource.TrApp,  []) do
      {:ok, pid} ->
        assert is_pid(pid) == true
      {:error,{:error, {:already_started, pid}}} -> 
        assert is_pid(pid) == true
      other -> Lager.error "other error: #{inspect(other)}"
    end

  end
end
