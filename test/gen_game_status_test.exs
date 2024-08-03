defmodule GenGameStatusTest do
  use ExUnit.Case, async: false
  doctest GenGameStatus

  @test_dir "test/test_games"

  @status_content """
  [COMPLETED]

  [PROGRESS]

  [PLAYING]

  [NOT PLAYED]
  game1.exe
  game2.exe
  """

  setup_all do
    File.mkdir!(@test_dir)
    File.write!(Path.join(@test_dir, "game1.exe"), "1001010")
    File.write!(Path.join(@test_dir, "game2.exe"), "1010101")

    on_exit(fn ->
      File.cd("..")
      File.rm_rf("test_games")
    end)
  end

  describe "main/1" do
    test "create new status" do
      GenGameStatus.main(@test_dir)

      assert File.read("status.toml") == {:ok, @status_content}
    end
  end
end
