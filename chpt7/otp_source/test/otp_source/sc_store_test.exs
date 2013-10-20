Code.require_file "test_helper.exs", Path.join(__DIR__, "..")

defmodule ScStoreTest do
  use ExUnit.Case, async: false
  use OtpSource.TestCase
  import OtpSource.ScStore
  require Lager

  test ".init should create a table with the same name as the module" do
    assert init == :ok
    assert Enum.member?(:ets.all, OtpSource.ScStore) == true
  end
   test ".insert should insert a value into the ets table" do
     init
     start_count = Enum.count(:ets.tab2list(OtpSource.ScStore))
     insert("sc_store_insert_test", 111)
     assert Enum.count(:ets.tab2list(OtpSource.ScStore)) > start_count 
   end
   test ".lookup should return the inserted key" do
     init
     insert("sc_store_hmm", 111)
     assert {:ok, 111} = lookup("sc_store_hmm")
   end
   test ".delete should delete the passed key" do
     init
     insert("sc_store_hmm", 111)
     delete(111)
     assert {:error, _} = lookup("sc_store_hmm")
   end
end
