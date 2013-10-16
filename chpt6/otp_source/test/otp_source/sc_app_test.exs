Code.require_file "test_helper.exs", Path.join(__DIR__, "..")

defmodule ScAppTest do
  use OtpSource.TestCase
  use Dynamo.HTTP.Case

  test "start should return ok with a valid process id" do
    {atom, pid} = OtpSource.ScApp.start(OtpSource.ScApp,  [])
    case OtpSource.ScApp.start(OtpSource.ScApp,  []) do
      {:ok, pid} ->
        assert is_pid(pid) == true
      {:error,{:error, {:already_started, pid}}} -> 
        assert is_pid(pid) == true
    end
  end

  #test "gen server start should return ok" do
  #  {atom, pid} = :gen_server.start_link(OtpSource.ScApp, :ok, [])
  #  assert atom == :ok
  #  assert is_pid(pid) == true
  #end

  test "cast stop should return ok" do
    atom = OtpSource.ScApp.stop([])
    assert atom == :ok
  end

  test "start should create an ets table" do
    {atom, pid} = OtpSource.ScApp.start(OtpSource.ScApp,  [])
    assert Enum.member?(:ets.all, OtpSource.ScStore) == true
  end

end
