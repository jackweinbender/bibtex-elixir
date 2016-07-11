defmodule Bibtex.ParserTest do
  use ExUnit.Case

  test "Throws Syntax Errors" do
    assert_raise SyntaxError, fn -> Bibtex.Parser.parse("type") end
    assert_raise SyntaxError, fn -> Bibtex.Parser.parse("type{citekey") end
  end
  test "Parse Entries" do
    input = """
    @article{huehnergard2014,
    	Author = {Huehnergard, John and Wilson-Wright, Aren},
    	Number = {1},
    	Pages = {7--17},
    	Title = {A {{Compound Etymology}} for {{Biblical Hebrew}} זוּלָתִי '{{Except}}'},
    	Volume = {55}}
    @inproceedings{stuckenbruck2007}
    @mvlexicon{olmo-letesanmartin2015,
    	Booktitle = {A Dictionary of the Ugaritic Language in the Alphabetic Tradition},
    	Editor = {del Olmo Lete, Gregorio and Sanmartín, Joaquín},
    	Location = {Leiden},
    	Publisher = {E.J. Brill},
    	Title = {A Dictionary of the Ugaritic Language in the Alphabetic Tradition},
    	Volumes = {2},
    	Year = {2015}}
    """
    expected = [
      %{
        entry_type: "article",
        citekey: "huehnergard2014",
        author: "Huehnergard, John and Wilson-Wright, Aren",
        number: "1",
        pages: "7--17",
        title: "A Compound Etymology for Biblical Hebrew זוּלָתִי 'Except'",
        volume: "55"
      },
      %{
        entry_type: "inproceedings",
        citekey: "stuckenbruck2007",
      },
      %{
        entry_type: "mvlexicon",
        citekey: "olmo-letesanmartin2015",
        booktitle: "A Dictionary of the Ugaritic Language in the Alphabetic Tradition",
        editor: "del Olmo Lete, Gregorio and Sanmartín, Joaquín",
        location: "Leiden",
        publisher: "E.J. Brill",
        title: "A Dictionary of the Ugaritic Language in the Alphabetic Tradition",
        volumes: "2",
        year: "2015"
      }
    ]
    assert Bibtex.Parser.parse(input) == expected
  end
end
