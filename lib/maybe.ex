defmodule Maybe do
  use FunLand.Monad

  defstruct nothing?: true, val: nil

  defimpl Inspect do
    def inspect(%Maybe{nothing?: true}, _opts), do: "#Maybe{Nothing}"
    def inspect(%Maybe{val: x}, _opts), do: "#Maybe{Just #{inspect x}}"
  end

  def nothing(), do: %Maybe{nothing?: true}
  def just(x), do: %Maybe{nothing?: false, val: x}

  def from_just(%Maybe{nothing?: false, val: x}), do: x
  def fromjust(%Maybe{}), do: raise "Passed value was nothing!"

  def ap(%Maybe{nothing?: true}, _), do: nothing()
  def ap(_, %Maybe{nothing?: true}), do: nothing()
  def ap(%Maybe{nothing?: false, val: fun}, %Maybe{nothing?: false, val: b}) when is_function(fun, 1) do
    just(fun.(b))
  end

  def of(x), do: just(x)

end
