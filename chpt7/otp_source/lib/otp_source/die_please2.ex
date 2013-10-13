defmodule OtpSource.DiePlease2 do
  @sleep_time 2000

  def go do
    ## just sleep for a while, then craxh
    :timer.sleep(@sleep_time)
    :i_really_want_to_die = :right_now
  end
end

