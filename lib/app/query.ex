defmodule App.Query do
  @moduledoc """
  Helper for composable query services.

  Provides wrappers for Repo calls with automatic parameter decomposition.

  Each parameter should be handled by a `compose/3` callback.

  List parameters may be further decomposed if they are signalled as composite fields:

  ```
  @composite :field
  ```

  Unhandled parameters will raise an exception, unless explicitly authorized with an attribute
  such as:

  ```
  @allow :field
  ```
  """

  defmacro __using__(_opts) do
    quote do
      Module.register_attribute(__MODULE__, :composite, accumulate: true)
      Module.register_attribute(__MODULE__, :allow, accumulate: true)

      @composite :with
      @composite :order_by

      import Ecto.Query
      alias App.Query
      alias App.Repo

      def one(params), do:
        __MODULE__
        |> Query.prepare_query(params)
        |> Repo.one()

      def all(params), do:
        __MODULE__
        |> Query.prepare_query(params)
        |> Repo.all()

      def prepare(params), do:
        __MODULE__
        |> Query.prepare_query(params)

      defp join_new(query, assoc), do:
        __MODULE__
        |> Query.join_new(query, assoc)

      @before_compile App.Query
    end
  end

  defmacro __before_compile__(_) do
    composite_fields = Module.get_attribute(__CALLER__.module, :composite, [])
    allowed_fields = Module.get_attribute(__CALLER__.module, :allow, [])

    quote do
      unless Enum.empty?(unquote(allowed_fields)) do
        def compose(query, _context, [{param, _value}]) when param in unquote(allowed_fields), do:
          query
      end

      def compose(query, _context, clause), do:
        raise "#{__MODULE__} unknown clause '#{inspect clause}'"

      def join(_query, assoc), do:
        raise "#{__MODULE__} attempted to join unknown assoc '#{inspect assoc}'!"

      def composite_fields, do:
        unquote(composite_fields)

      defoverridable compose: 3
    end
  end

  defguardp is_enum(field) when is_list(field) or is_map(field)

  def prepare_query(module, params) do
    params
    |> module.start_query()
    |> compose_params(module, params)
  end

  defp compose_params(query, module, params) do
    Enum.reduce(params, query, fn {param, value}, query_acc ->
      compose_single_param(query_acc, module, param, value, params)
    end)
  end

  # Some params (e.g. :where) are expected to have lists of clauses
  # and be evaluated separately. These params must be signalled with the
  # `@composite` attribute.
  defp compose_single_param(query, module, param, value, context) do
    if is_enum(value) and param in module.composite_fields do
      Enum.reduce(value, query, fn value, query_acc ->
        module.compose(query_acc, context, [{param, value}])
      end)
    else
      module.compose(query, context, [{param, value}])
    end
  end

  def join_new(module, query, assoc) do
    if Ecto.Query.has_named_binding?(query, assoc) do
      query
    else
      module.join(query, assoc)
    end
  end
end
