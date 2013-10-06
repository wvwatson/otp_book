Code.require_file "test_helper.exs", Path.join(__DIR__, "..")

defmodule SimpleCacheTest do
  use ExUnit.Case, async: false
  use OtpSource.TestCase
  use Dynamo.HTTP.Case
  import OtpSource.SimpleCache
  require Lager
  
  test ".insert should replace a key in the store if the key (pid) already exists" do
    {_cstarted, cpid} = OtpSource.ScElement.create("simple_cache_test_key")
    OtpSource.SimpleCache.insert("simple_cache_test_key", "myvalue")
    [{value, pid}] = :ets.lookup(OtpSource.ScStore, "simple_cache_test_key") 
    assert value == "simple_cache_test_key" 
  end
  test ".lookup should find a key in the store" do
    OtpSource.SimpleCache.insert("simple_cache_test_lookup_key", "myvalue")
    value = OtpSource.SimpleCache.lookup("simple_cache_test_lookup_key")
    assert value == {:ok , "myvalue" }
  end
  test ".delete remove a key from the store" do
    OtpSource.SimpleCache.insert("simple_cache_test_delete_key", "myvalue")
    value = OtpSource.SimpleCache.delete("simple_cache_test_delete_key")
    assert {:error, :not_found} == OtpSource.SimpleCache.lookup("simple_cache_test_delete_key")
  end
end
