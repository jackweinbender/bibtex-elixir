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
  test "Parse Minimal Entry" do
    input = ~s(@inproceedings{stuckenbruck2007})
    expected = [%{:entry_type => "inproceedings", :citekey => "stuckenbruck2007"}]

    assert Bibtex.Parser.parse(input) == expected
  end
  test "Parse Bibtex File" do
    input = File.read!('test/data/single.bib')
    expected = [%{
      :entry_type => "incollection",
      :citekey => "kitagawa2005",
      :author => "Kitagawa, Joseph M.",
      :title => "Encyclopedia of Religion"
    }]

    assert Bibtex.Parser.parse(input) == expected
  end
end
