Code.require_file "test_helper.exs", Path.join(__DIR__, "..")
defmodule ScEventTest do
  use ExUnit.Case, async: false
  use OtpSource.TestCase
  import OtpSource.ScEvent
  require Lager

  test "start_link should return ok" do                        
    case start_link do                                    
      {_atom, {msg, pid}} ->                               
          assert msg == :already_started                  
          assert is_pid(pid) == true                      
      {atom, pid} ->                                      
          assert atom == :ok                              
          assert is_pid(pid) == true                      
    end
  end

end
