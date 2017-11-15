defmodule DnstoreTest do
  use ExUnit.Case
  doctest Dnstore

  test "greets the world" do
    assert Dnstore.hello() == :world
  end
end
