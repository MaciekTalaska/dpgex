defmodule Dpgex.DicewareRepositoryFileNotFoundException do
  defexception message: "Diceware list for requested language not found!"
end

defmodule Dpgex.DicewareRepository do
  @moduledoc """
  DicewareRepository module - exposes methods that return language specific data, such as:
  - list of diceware words for the language
  - length of the list

  Data for English (en) and Polish (pl) is part of the module - these two languages are available by default. It is easy to add additional language by adding text file to the same directory where Dpgex is located.

  The text file should follow the naming convention of: `diceware-xy.txt`, where xy is the 2 character code for the language (for example: es for Spanish, pt for Portugese, de for German etc.)

  The file should have a very simple format: each line should contain one word only. It is possible to provide files with diceware indices before each word (so the format is: "index<separator>word". Separator should be either tab(s) or space(s)). If file containing indices is provided, these will be stripped out and not used.

  Module exposes following methods:
  - get_repository(language)
  - get_repository!(language)
  - get_all_repositories()
  - get_supported_languages()
  """

  @external_resource "priv/diceware-pl.txt"
  @pl_diceware File.read! "priv/diceware-pl.txt"
  defp read_polish_diceware_list, do: @pl_diceware

  @external_resource "priv/diceware-en.txt"
  @en_diceware File.read! "priv/diceware-en.txt"
  defp read_english_diceware_list, do: @en_diceware

  defp extract_words_from_file_content(lines) do
    lines
    |> String.split("\n")
    |> Enum.map(fn x -> x |> String.split |> List.last end)
    |> Enum.drop(-1)
  end

  defp repository_from_content(lines) do
    words = extract_words_from_file_content(lines)
    %{ :length => Kernel.length(words),
       :words => extract_words_from_file_content(lines)
    }
  end

  defp extract_language_from_filename(filename) do
    filename
    |> String.downcase
    # Piping to the second argument taken from: https://shulhi.com/piping-to-second-argument-in-elixir/
    |> (&Regex.named_captures(
          ~r/(?<p>diceware-)(?<language>[a-z]{2})(?<ext>.*)/,
        &1)).()
    |> Map.get("language")
  end

  defp get_local_diceware_files() do
    files = case File.ls do
              {:error, reason} -> throw reason
              {:ok, files} -> files
            end
    files |> Enum.filter(fn x -> x |> String.contains?("diceware-") end)
  end

  defp available_languages_from_files do
    get_local_diceware_files()
    |> Enum.map( fn f -> {f |> extract_language_from_filename(),f} end)
  end

  defp repository_from_file(filename) do
    file_content = case File.read filename do
      {:error, reason } -> throw reason
      {:ok, body} -> body
    end

    language = extract_language_from_filename(filename)

    {String.to_atom(language),
      repository_from_content(file_content)
    }
  end

  defp repositories_from_local_files do
    get_local_diceware_files()
    |> Enum.map(fn f -> f |> repository_from_file end)
  end

  @doc """
  Returns list of all available repositories (for all supported languages).


  ## Examples

      iex> Dpgex.DicewareRepository.get_all_repositories
      [
        pl: %{
          length: 3888,
          words: ["absurd", "absynt", "adept", "adidas", "adonis", "adres", "adwent",
          "aerob", "afekt", "afera", "afgan", "afisz", "afro", "agat", "agenda",
          "agent", "agitka", "agonia", "agrest", "akacja", "akapit", "akces",
          "akcja", "akcyza", "akord", "akryl", "akson", "aktor", "alarm", "alba",
          "album", "aleja", "alejka", "alert", "alga", "alians", "alkowa", "alpaga",
          "altana", "alumn", "aluzja", "amant", "amator", "ambona", "ameba",
          "ameryka", "amfora", ...]
        },
        en: %{
          length: 1296,
          words: ["ardvark", "abandoned", "abbreviate", "abdomen", "abhorrence",
          "abiding", "abnormal", "abrasion", "absorbing", "abundant", "abyss",
          "academy", "accountant", "acetone", "achiness", "acid", "acoustics",
          "acquire", "acrobat", "actress", "acuteness", "aerosol", "aesthetic",
          "affidavit", "afloat", "afraid", "aftershave", "again", "agency",
          "aggressor", "aghast", "agitate", "agnostic", "agonizing", "agreeing",
          "aidless", "aimlessly", "ajar", "alarmclock", "albatross", "alchemy",
          "alfalfa", "algae", "aliens", "alkaline", "almanac", ...]
        }
      ]
  """
  @spec get_all_repositories() :: [{:key, %{:length => integer, :words => [String.t]}}]
  def get_all_repositories do
    inner = [
      pl: repository_from_content(read_polish_diceware_list()),
      en: repository_from_content(read_english_diceware_list())
    ]
    local = repositories_from_local_files()
    inner ++ local
  end

  defp repository_from_file_by_language(language) do
    languages = available_languages_from_files()
    language_file = languages |> Enum.find(fn ls -> elem(ls, 0) == language end)
    case language_file == nil do
      true -> {:error, :enoent}
      false ->
        {_, filename} = language_file
        {_, repo_content} = repository_from_file(filename)
        {:ok, repo_content}
    end
  end

  @doc """
  Returns list of supported languages. Each element of the list is 2 character string. These elements could be used as parameter for calling `get_repository(language)`.

  ## Examples

      iex> Dpgex.DicewareRepository.get_supported_languages
      ["pl", "en", "fi", "mi"]
  """
  @spec get_supported_languages() :: [String.t]
  def get_supported_languages do
    languages_from_files = available_languages_from_files()
      |> Enum.map(fn l -> elem(l, 0) end)
    ["pl", "en"] ++ languages_from_files
  end

  @doc """
  Returns repository for specified language. Language should be provided as string.

  If repository for specified language could be created:
  {:ok, repository_data}
  In case it is not possible to return requested repository, following tuple is returned:
  {:error, _}

  ## Examples

      iex> Dpgex.DicewareRepository.get_repository("pl")
      {:ok,
      %{
      length: 3888,
      words: ["absurd", "absynt", "adept", "adidas", "adonis", "adres", "adwent",
      "aerob", "afekt", "afera", "afgan", "afisz", "afro", "agat", "agenda",
      "agent", "agitka", "agonia", "agrest", "akacja", "akapit", "akces", "akcja",
      "akcyza", "akord", "akryl", "akson", "aktor", "alarm", "alba", "album",
      "aleja", "alejka", "alert", "alga", "alians", "alkowa", "alpaga", "altana",
      "alumn", "aluzja", "amant", "amator", "ambona", "ameba", "ameryka", ...]
      }}

      iex> Dpgex.DicewareRepository.get_repository("pt")
      {:error, :enoent}
  """
  @spec get_repository(String.t) :: {:ok , %{:length => integer, :words => [String.t]}}
  @spec get_repository(String.t) :: {:error, :enoent}
  def get_repository(language) do
    case language do
      "pl" -> {:ok,
              repository_from_content(read_polish_diceware_list()) }
      "en" -> {:ok,
              repository_from_content(read_english_diceware_list())}
      _ -> repository_from_file_by_language(language)
    end
  end

  @doc """
  Returns repository data as map of the following structure:

  `{:length Number, :words [list of words]}`

  In case word list for requested language does not exist `Dpgex.DicewareRepositoryFileNotFoundException` is raised

  ## Examples

      iex> Dpgex.DicewareRepository.get_repository!("en")
      %{
      length: 1296,
      words: ["ardvark", "abandoned", "abbreviate", "abdomen", "abhorrence",
      "abiding", "abnormal", "abrasion", "absorbing", "abundant", "abyss",
      "academy", "accountant", "acetone", "achiness", "acid", "acoustics",
      "acquire", "acrobat", "actress", "acuteness", "aerosol", "aesthetic",
      "affidavit", "afloat", "afraid", "aftershave", "again", "agency",
      "aggressor", "aghast", "agitate", "agnostic", "agonizing", "agreeing",
      "aidless", "aimlessly", "ajar", "alarmclock", "albatross", "alchemy",
      "alfalfa", "algae", "aliens", "alkaline", "almanac", "alongside", "alphabet",
      ...]
      }

      iex> Dpgex.DicewareRepository.get_repository!("de")
      ** (Dpgex.DicewareRepositoryFileNotFoundException) Diceware list for requested language not found!
      (dpgex) lib/dpgex/repository.ex:159: Dpgex.DicewareRepository.get_repository!/1
  """
  @spec get_repository!(String.t) :: %{:length => integer, :words => [String.t]}
  def get_repository!(language) do
    case language do
      "pl" -> repository_from_content(read_polish_diceware_list())
      "en" -> repository_from_content(read_english_diceware_list())
      _ -> result = repository_from_file_by_language(language)
        case result do
          {:ok, body} -> body
          {:error, _} -> raise Dpgex.DicewareRepositoryFileNotFoundException
        end
    end
  end
end
