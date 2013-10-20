defmodule OtpSource.SimpleCache do
  require Lager
  def insert(key, value) do
    Lager.debug "simple cache"
    Lager.debug "simple cache lookup: #{inspect(OtpSource.ScStore.lookup(key))}"
    case OtpSource.ScStore.lookup(key) do
      {:ok, pid} ->
        Lager.debug "simple cache replace"
        Lager.debug "simple cache replace: #{inspect(OtpSource.ScElement.replace(pid, value))}"
        OtpSource.ScElement.replace(pid, value)
      {:error, _} ->
        Lager.debug "simple cache error and create"
        {:ok, pid} = OtpSource.ScElement.create(value)
        OtpSource.ScStore.insert(key, pid)
    end
  end

  def lookup(key) do
    try do
      Lager.debug "in simple cache lookup"
      {:ok, pid} = OtpSource.ScStore.lookup(key)
      {:ok, value} = OtpSource.ScElement.fetch(pid)
      Lager.debug "simple cache fetch: #{inspect(value)}"
      {:ok, value}
    rescue
      x ->
        Lager.error "simple cache error"
        {:error, x.message}
    catch
       :exit, {:noproc, {:gen_server, :call, [pid, :fetch]}} -> 
            {:error, :not_found}
       :exit, {:normal, {:gen_server, :call, [pid, :fetch]}} -> 
            {:error, :not_found}
    end
  end
  
  def delete(key) do
    case OtpSource.ScStore.lookup(key) do
      {:ok, pid} ->
        OtpSource.ScElement.delete(pid)
      {:error, _reason} ->
        :ok
    end
  end
end
