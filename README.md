# Dpgex Diceware™ Password Generator in Elixir

This is a simple application that aims to help generating easy to remember passwords using Diceware method.

This is Elixir version of the [Diceware Password Generator](https://github.com/MaciekTalaska/dpg) in Rust I have written some time ago.

## What is Diceware™ method?

In short - this method allows generating passwords that are relatively easy to remember by humans, but are still safe to use (when generated properly). The best explanation of the method is below strip from [xkcd](https://xkcd.com/) comic:

![alt text](https://imgs.xkcd.com/comics/password_strength.png "xkcd on Diceware")

## Diceware™

[Diceware](http://world.std.com/~reinhold/diceware.html) is a trademark of A G Reinhold. Please check the site to get more details on the method.

## Diceware™ lists used:

This repo includes several diceware list:
- diceware-mi.txt
- diceware-fi.txt
These two lists are taken from: https://github.com/mgumz/diceware/tree/master/lists (diceware-mi.txt is originally named `diceware-maori.txt` and was renamed for consistency). 
- diceware-en.txt - this is short list for English taken from EFF, you may obtain the origianl from: https://www.eff.org/pl/deeplinks/2016/07/new-wordlists-random-passphrases
- diceware-pl.txt - this list is created by me. For more info: https://github.com/MaciekTalaska/diceware-pl

## Installation

**Note:** this package is not ready yet, and is not available on hex. Same is with the docs...

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `dpgex` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:dpgex, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/dpgex](https://hexdocs.pm/dpgex).

