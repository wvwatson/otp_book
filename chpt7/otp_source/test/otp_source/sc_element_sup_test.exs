Code.require_file "test_helper.exs", Path.join(__DIR__, "..")

defmodule ScElementSupTest do 
  use ExUnit.Case, async: false
  use OtpSource.TestCase
  use Dynamo.HTTP.Case
  import OtpSource.ScElementSup
  require Lager

  test "server should contain module name" do
    assert server_name == OtpSource.ScElementSup 
  end

  # next test needs start_link *and* init defined in order to work
  test "start should return ok" do
    Lager.debug "the ScElementSup.start_link test will fail on some runs and succeed on others for some reason ... perhaps we need a delay?"
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

  test ".start_child should start a child element" do
    # must start supervisor first
    Lager.debug "the ScElmentSup.start_child test will fail on some runs and succeed on others for some reason ... perhaps we need a delay?"
    {_atom, _pid} = OtpSource.ScApp.start(OtpSource.ScApp,  [])
    # had to create ScElement first for this to work
    {scstarted, scpid} = start_child("hmm", (60 * 60 * 24))
    assert scstarted == :ok
    assert is_pid(scpid) == true
    #ret = :gen_server.cast(scpid, :stop)
  end

end
