defmodule AppWeb.TodoItemController do
  use AppWeb, :controller

  alias App.Todos

  def index(conn, _params) do
    entries = Todos.list_todo_items()
    render(conn, "index.html", entries: entries)
  end
end
