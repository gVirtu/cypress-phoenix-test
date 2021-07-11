defmodule App.Todos.TodoItemQueryTest do
  use App.DataCase
  alias App.Todos.TodoItemQuery

  setup ctx do
    ctx
    |> Map.merge(%{
      item1: insert(:todo_item),
      item2: insert(:todo_item)
    })
  end

  # Filters

  describe "search filtering" do
    test "by id", ctx do
      [entry] = TodoItemQuery.all(%{id: ctx.item1.id})
      assert entry.id == ctx.item1.id
    end
  end
end
