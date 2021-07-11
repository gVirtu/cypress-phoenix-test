defmodule App.Todos do
  @moduledoc """
  The TODOs context.
  """

  alias App.Todos.TodoItemQuery

  def list_todo_items(params \\ []), do: TodoItemQuery.all(params)
end
