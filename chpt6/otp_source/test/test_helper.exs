Dynamo.under_test(OtpSource.Dynamo)
Dynamo.Loader.enable
ExUnit.start
require Lager
Lager.compile_log_level(:info)
Lager.compile_log_level(:debug)
:lager.start

#{_,cwd}=Path.cwd
#appdir=Path.expand("../#{cwd}")

defmodule OtpSource.TestCase do
  use ExUnit.CaseTemplate

  # Enable code reloading on test cases
  setup do
    Dynamo.Loader.enable
    :ok
  end
end
