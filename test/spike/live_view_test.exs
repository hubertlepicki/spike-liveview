defmodule Spike.LiveViewTest do
  use ExUnit.Case
  doctest Spike.LiveView

  test "greets the world" do
    assert Spike.LiveView.hello() == :world
  end
end
