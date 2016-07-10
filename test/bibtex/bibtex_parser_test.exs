defmodule Bibtex.ParserTest do
  use ExUnit.Case

  test "Throws Syntax Errors" do
    assert_raise SyntaxError, fn -> Bibtex.Parser.parse("type") end
    assert_raise SyntaxError, fn -> Bibtex.Parser.parse("type{citekey") end
  end
  test "Parse Entry" do
    input = ~s(@entry{citekey,\ntitle = {Ti{t}le},\nauthor = {Name}})
    expected = [%{
      :entry_type => "entry",
      :citekey => "citekey",
      :title => "Title",
      :author => "Name"
    }]
    assert Bibtex.Parser.parse(input) == expected
  end
end
