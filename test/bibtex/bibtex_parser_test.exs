defmodule Bibtex.ParserTest do
  use ExUnit.Case

  test "Split Entries" do
    input = ~s(@one@two@three four%comment\n@five@six%comment)
    expected = ["one", "two", "three four", "five", "six"]

    assert Bibtex.Parser.splitEntries(input) == expected
  end

  test "Parse Entry" do

    input = ~s(entry@citekey{title = {Title}, author = {Name}})
    expected = %{
      :entry_type => "entry",
      :citekey => "citekey",
      #:attrs => [{:title, "Title"}, {:author, "Name"}]
      :attrs => "Attrs"
    }

    assert Bibtex.Parser.getEntryType(input) == expected

    assert_raise SyntaxError, fn -> Bibtex.Parser.getEntryType("Alpha") end
    assert_raise SyntaxError, fn -> Bibtex.Parser.getEntryType("Alpha@citekey") end

  end

end
