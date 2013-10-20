Code.require_file "test_helper.exs", Path.join(__DIR__, "..")

defmodule ScElementTest do
  use ExUnit.Case, async: false
  use OtpSource.TestCase
  use Dynamo.HTTP.Case
  import OtpSource.ScElement
  require Lager


  setup_all do
    # must start supervisor first
    case OtpSource.ScApp.start(OtpSource.ScApp,  []) do
      {:ok,pid} -> {:ok, setuppid: pid}
      {:error,{:error, {:already_started, pid}}} -> {:ok, setuppid: pid}
      other -> Lager.debug "OtpSource.ScApp.start ret: #{inspect(other)}"; other
    end
  end
  test ".create/2 should start a child process with the passed state" do
    {scstarted, scpid} = create("hmm", (60 * 60 * 24))
    assert scstarted == :ok
    assert is_pid(scpid) == true
  end
  test ".create/1 should start a child process with the passed state" do
    {scstarted, scpid} = create("hmm")
    assert scstarted == :ok
    assert is_pid(scpid) == true
  end
  test ".time_left/2 _/atom should return infinity" do 
    now = :calendar.local_time
    start_time = :calendar.datetime_to_gregorian_seconds(now)
    assert :infinity == time_left(start_time, :infinity)
  end
  test ".time_left/2 _/_ should return a good lease" do 
    now = :calendar.local_time
    start_time = :calendar.datetime_to_gregorian_seconds(now)
    assert 0 == time_left(0, 5000)
    assert 5000000 <= time_left(start_time, 5000)
  end
  test ".fetch should return the value for some saved state" do 
    {scstarted, scpid} = create("sc_element_hmm")
    fret = fetch(scpid)
    assert fret == {:ok, "sc_element_hmm"}
  end
  test ".replace should return a new value for s valuome saved state" do 
    {cstarted, cpid} = create("sc_element_hmm")
    ret = :gen_server.cast(cpid, {:replace, "sc_element_hmm2"})
    assert ret == :ok
    fret = fetch(cpid)
    assert fret == {:ok, "sc_element_hmm2"}
  end
  test ".handle_cast/2 tuple should return a new value for some saved state" do 
    {cstarted, cpid} = create("hmm")
    ret = replace(cpid, "hmm2")
    assert ret == :ok
    fret = fetch(cpid)
    assert fret == {:ok, "hmm2"}
  end
  test ".delete should remove a value and its process from the universe", meta do
    apppid = meta[:setuppid]
    {cstarted, cpid} = create("hmm")
    ret = OtpSource.ScElement.delete(cpid)
    assert ret == :ok
    Lager.debug "info cpid: #{inspect(Process.info(cpid))}"
    Lager.debug "info apppid: #{inspect(Process.info(apppid))}"
    Lager.debug "alive? cpid: #{inspect(Process.alive?(cpid))}"
    Lager.debug "alive? apppid: #{inspect(Process.alive?(apppid))}"
    Lager.debug "this probably needs a delay ... sometimes this fails"
    assert Process.alive?(cpid) == false
  end
end
