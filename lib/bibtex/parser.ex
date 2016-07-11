defmodule Bibtex.Parser do
  def parse(string) do
    splitEntries(string)
    |> Enum.map(&parseEntry/1)
  end

  defp splitEntries( _rest , entries \\ [], acc \\ [])
  defp splitEntries("\%" <> rest, entries, acc) do
    comment(rest, entries, acc)
  end
  defp splitEntries("\@" <> rest, entries, acc) do
    case Enum.empty?(entries) and Enum.empty?(acc) do
      true  -> splitEntries(rest) # First Entry
      false -> splitEntries(rest, [ to_string(Enum.reverse(acc)) | entries ])
    end
  end
  defp splitEntries("\n"<>rest, entries, acc), do: splitEntries(rest, entries, acc)
  defp splitEntries(<<char::utf8, rest::binary>>, entries, acc) do
    splitEntries(rest, entries, [ char | acc ])
  end
  defp splitEntries( _else , entries, acc) do
    Enum.reverse([ to_string(Enum.reverse(acc)) | entries ])
  end

  defp comment("\n" <> rest, entries, acc), do: splitEntries(rest, entries, acc)
  defp comment(<<_char::utf8, rest::binary>>, entries, acc), do: comment(rest, entries, acc)
  defp comment( _else , entries, acc) do
    Enum.reverse([ to_string(Enum.reverse(acc)) | entries ])
  end

  ## @ has been removed by splitEntries/1, so citekey is the first chars before "{"
  ## Move on to citekey once the first "{" has been reached
  defp parseEntry( _rest , map \\ %{:entry_type => '', :citekey => ''}, acc \\ [])
  defp parseEntry("\{" <> rest, map, acc) do
    map = %{map | :entry_type => to_string(Enum.reverse(acc)) }
    getCiteKey(rest, map)
  end
  defp parseEntry(<<char::utf8, rest::binary>>, map, acc) do
    parseEntry(rest, map, [ char | acc ])
  end
  defp parseEntry(_else, _map, _acc), do: raise SyntaxError

  ## Parse to first "," to retrieve citekey
  ## Move on to Attrs once citekey has been established
  defp getCiteKey( _rest , _citekey, acc \\ [])
  defp getCiteKey("\," <> rest, map, acc) do
    getAttrs(rest, %{map | :citekey => to_string(Enum.reverse(acc)) } )
  end
  defp getCiteKey("}" <> rest, map, acc) do
    %{map | :citekey => to_string(Enum.reverse(acc)) }
  end
  defp getCiteKey(<<char::utf8, rest::binary>>, map, acc) do
    getCiteKey(rest, map, [ char | acc ])
  end
  defp getCiteKey(_else, _map, _acc), do: raise SyntaxError

  defp getAttrs(_rest, _map, acc \\ [], depth \\ 0)
  defp getAttrs("\}"<>rest, map, acc, depth) when depth == 0 do
    attr = Enum.reverse(acc)
      |> to_string()
      |> String.trim()
      |> parseAttr()
    getAttrs(rest, Map.merge(map, attr))
  end
  defp getAttrs("\}"<>rest, map, acc, depth), do: getAttrs(rest, map, acc, depth - 1)
  defp getAttrs("\{"<>rest, map, acc, depth), do: getAttrs(rest, map, acc, depth + 1)
  defp getAttrs("\,"<>rest, map, acc, depth) when depth == 0 do
    attr = Enum.reverse(acc)
      |> to_string()
      |> String.trim()
      |> parseAttr()
    getAttrs(rest, Map.merge(map, attr))
  end
  defp getAttrs(<<char::utf8, rest::binary>>, map, acc, depth) do
    getAttrs(rest, map, [ char | acc ], depth)
  end
  defp getAttrs(_rest, map, _acc, depth), do: map
  defp parseAttr(attr_string) do
    [head | [tail]] =
      String.split(attr_string, "=")
      |> Enum.map(fn(s) -> String.trim(s) end)
    %{format_atom(head) => tail}
  end

  defp format_atom(string) do
    String.downcase(string)
    |> String.to_atom()
  end
end


# put_new_lazy(map, key, fun)
# Evaluates fun and puts the result under key in map unless key is already present
