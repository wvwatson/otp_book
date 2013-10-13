defmodule OtpSource.CustomErrorReport do
  GenServer.Behaviour

  defrecord State, name: nil

  def register_with_logger do
    :error_logger.add_report_handler(__MODULE__)
  end

  def init([]) do
    {:ok, State.new}
  end

  # listing 7.3
  #def handle_event(_event, state) do
  #  {:ok, state}
  #end

  # listing 7.4
  def handle_event({:error, _gleader, {pid, format, data}}, state) do
    :io.fwrite("ERROR <~p> ~s", [pid, :io_lib.format(format, data)])
    {:ok, state}
  end

  def handle_event({:error_report, _gleader, {pid, :std_error, report}}, state) do
    :io.fwrite("ERROR <~p> ~p", [pid, report])
    {:ok, state}
  end

  def handle_event({:error_report, _gleader, {pid, type, report}}, state) do
    :io.fwrite("ERROR <~p> ~p ~p", [pid, report])
    {:ok, state}
  end

  def handle_event({:warning_msg, _gleader, {pid, format, data}}, state) do
    :io.fwrite("WARNING <~p> ~s", [pid, :io_lib.format(format, data)])
    {:ok, state}
  end

  def handle_event({:warning_report, _gleader, {pid, :std_warning, report}}, state) do
    :io.fwrite("WARNING <~p> ~p", [pid, report])
    {:ok, state}
  end

  def handle_event({:warning_report, _gleader, {pid, type, report}}, state) do
    :io.fwrite("WARNING <~p> ~p ~p", [pid, type, report])
    {:ok, state}
  end

  def handle_event({:info_msg, _gleader, {pid, format, data}}, state) do
    :io.fwrite("INFO <~p> ~s", [pid, :io_lib.format(format, data)])
    {:ok, state}
  end
 
  def handle_event({:info_report, _gleader, {pid, :std_info, report}}, state) do
    :io.fwrite("INFO <~p> ~p", [pid, report])
    {:ok, state}
  end

  def handle_event({:info_report, _gleader, {pid, type, report}}, state) do
    :io.fwrite("INFO <~p> ~p ~p", [pid, type, report])
    {:ok, state}
  end
  
  def handle_event(_event, state) do
    {:ok, state}
  end

  # end of listing 7.4

  def handle_call(_request, state) do
    reply = :ok
    {:ok, reply, state}
  end

  def handle_info(_info, state) do
    {:ok, state}
  end

  def terminate(_reason, _state) do
    :ok
  end

  def code_change(_pldvsn, state, _extra) do
    {:ok, state}
  end
end
