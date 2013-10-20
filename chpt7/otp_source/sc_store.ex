defmodule OtpSource.ScStore do
  use GenServer.Behaviour
  require Lager

  @table_id __MODULE__

  def init do
   unless Enum.member?(:ets.all,OtpSource.ScStore), do: :ets.new(@table_id, [:public, :named_table])
    :ok
  end

  def insert(key, pid) do
    :ets.insert(@table_id, {key, pid})
  end

  def lookup(key) do
    #OtpSource.ScStore.init
    Lager.debug "sc_store lookup key: #{inspect(key)}"
    Lager.debug "ets.lookup : #{inspect(:ets.lookup(@table_id, key))}"
    case :ets.lookup(@table_id, key) do
      [{key, pid}] -> {:ok, pid}
      [] -> {:error, :not_found}
    end
  end

  def delete(pid) do
    # doesn't work
    #:ets.match_delete(@table_id, {'_', pid})
    # needs to be compiled?
    #ms = :ets.fun2ms(fn({m,n}) when n == pid -> true end)
    :ets.select_delete(@table_id, [{{:"$1", :"$2"}, [{:==, :"$2", pid}], [true]}]) 
  end

end
