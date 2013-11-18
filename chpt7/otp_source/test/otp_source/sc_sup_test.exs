Code.require_file "test_helper.exs", Path.join(__DIR__, "..")

defmodule ScSupTest do 
  use ExUnit.Case, async: false
  use OtpSource.TestCase
  use Dynamo.HTTP.Case
  import OtpSource.ScSup
  require Lager

  test "server should contain module name" do
    assert server_name == OtpSource.ScSup 
  end

  # next test needs start_link *and* init defined in order to work
  test "start should return ok" do
    Lager.debug "the ScSup.start_link test will fail on some runs and succeed on others for some reason ... perhaps we need a delay?"
    Lager.debug "start_link: #{inspect(start_link)}"
    # test that supervisor started with the application
    case start_link do
      {atom, {msg, pid}} ->  
          assert msg == :already_started
          assert is_pid(pid) == true
      {atom, pid} ->  
          assert atom == :ok
          assert is_pid(pid) == true
    end
  end
end

