defmodule FunLand.Mappable do
  @moduledoc """
  Something is Mappable if there is a way to map a function over it.

  `mapping` means to apply a transformation to the contents, without changing the structure.


  This module both contains the Mappable behaviour, which might be added 
  to your modules/structures by using `use Mappable` from within them,
  as well as the `Mappable.map(mappable, fun)` function, which will dispatch to whatever structure is passed in as first argument.


  In Category Theory, something that is Mappable is called a *Functor*.

  ## Fruit Salad Example

  Say we have an apple. There are many _operations_ we could do with an apple, such as peel it, slice it, juice it, etc.

  However, right now we don't have an apple, but a bowl filled with apples. How can we make sure we can still use all the operations we could on single apples?

  The answer: We need to take the apples one-by-one from the bowl, perform the desired operation, and then put them back in the bowl.

  This 'take -> perform -> put back' is the implementation of `map` for a bowl. It works similar for other data structures:

  Exactly _how_ to take something and put a result back, and _when_ to perform the desired operation (if we have an empty bowl, for instance, there's nothing to do)
  is what you need to define in your implementation.

  """

  @type mappable(_) :: FunLand.adt
  @callback map(mappable(a), (a -> b)) :: mappable(b) when a: any, b: any

  def __using__(_opts) do
    quote do
      @behaviour FunLand.Mappable
    end
  end


  # # Lists
  # def map(list, function) when is_list(list) do
  #   :lists.map(function, list)
  # end

  # # Tuples; Not fast, but possible
  # def map(tuple, function) when is_tuple(tuple) do
  #   tuple 
  #   |> Tuple.to_list 
  #   |> fn list -> :lists.map(function, list) end.() 
  #   |> List.to_tuple
  # end

  @doc """
  Maps the function `function` over all things inside `mappable`.

  Exactly what this means, depends on the structure of `mappable`.

  For lists, for instance, this means that all of the elements will be transformed by `function`.
  For the `Maybe` monad, this will do nothing if `Maybe` is `Nothing`, while it will transform whatever is inside
  if the `Maybe` is `Just something`.
  """
  def map(mappable, function)

  # Structs with user-defined specification.
  def map(mappable = %mappable_module{}, function) when is_function(function, 1) do
    mappable_module.map(mappable, function)
  end


  for {guard, module} <- FunLand.Builtin.__builtin__ do
    def map(mappable, function) when is_function(function, 1) and unquote(guard)(mappable) do
      apply(unquote(module), :map, [mappable, function])
    end
  end


  # # Maps.
  # def map(map = %{}, function) do
  #   # The passed function ought to have arity 1. For maps, this therefore means converting 
  #   # the two arguments from :maps.map to a {k, v} tuple.
  #   :maps.map(fn k, v -> function.({k, v}) end, map)
  # end
end