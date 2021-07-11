defmodule App.Todos.TodoItem do
  use App, :schema

  schema "todo_items" do
    field :name, :string
    field :description, :string
    field :completed_at, :utc_datetime_usec

    timestamps()
  end
end
