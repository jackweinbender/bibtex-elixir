defmodule Bibtex.Parser do

  @doc """
  Splits a string into a list of Entries
  """
  def splitEntries( _rest , entries \\ [], acc \\ [])
  def splitEntries("\%" <> rest, entries, acc) do
    comment(rest, entries, acc)
  end
  def splitEntries("\@" <> rest, entries, acc) do
    case Enum.empty?(entries) and Enum.empty?(acc) do
      true  -> splitEntries(rest) # First Entry
      false -> splitEntries(rest, [ to_string(Enum.reverse(acc)) | entries ])
    end
  end
  def splitEntries(<<char::utf8, rest::binary>>, entries, acc) do
    splitEntries(rest, entries, [ char | acc ])
  end
  def splitEntries( _else , entries, acc) do
    Enum.reverse([ to_string(Enum.reverse(acc)) | entries ])
  end

  defp comment("\n" <> rest, entries, acc), do: splitEntries(rest, entries, acc)
  defp comment(<<_char::utf8, rest::binary>>, entries, acc), do: comment(rest, entries, acc)
  defp comment( _else , entries, acc) do
    Enum.reverse([ to_string(Enum.reverse(acc)) | entries ])
  end

  def getEntryType( _rest , map \\ %{:entry_type => '', :citekey => '', :attrs => nil}, acc \\ [])
  def getEntryType("\@" <> rest, map, acc) do
    map = %{map | :entry_type => to_string(Enum.reverse(acc)) }
    getCiteKey(rest, map)
  end
  def getEntryType(<<char::utf8, rest::binary>>, map, acc) do
    getEntryType(rest, map, [ char | acc ])
  end
  def getEntryType(_else, _map, _acc), do: raise SyntaxError

  def getCiteKey( _rest , _citekey, acc \\ [])
  def getCiteKey("\{" <> rest, map, acc) do
    %{map | :citekey => to_string(Enum.reverse(acc)),
          :attrs => "Attrs" }
  end
  def getCiteKey(<<char::utf8, rest::binary>>, map, acc) do
    getCiteKey(rest, map, [ char | acc ])
  end
  def getCiteKey(_else, _map, _acc), do: raise SyntaxError

end
