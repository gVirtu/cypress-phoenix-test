defmodule App.Todos.TodoItemQuery do
  @moduledoc """
  Queries for the TodoItem entity.
  """

  use App.Query

  def start_query(_ctx) do
    from(c in App.Todos.TodoItem)
  end

  def compose(query, _ctx, id: value) do
    where(query, id: ^value)
  end
end
