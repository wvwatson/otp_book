Code.require_file "test_helper.exs", Path.join(__DIR__, "..") 
defmodule CustomErrorReportTest do
  use OtpSource.TestCase 
  use Dynamo.HTTP.Case
  import OtpSource.CustomErrorReport

  test ".init should create a table with the same name as the module" do
    assert init([]) == {:ok, OtpSource.CustomErrorReport.State.new}
  end 
end
