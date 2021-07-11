defmodule AppWeb.TodoItemControllerTest do
  use AppWeb.ConnCase

  # Index

  describe "index" do
    setup ctx do
      items = insert_list(5, :todo_item)

      Map.put(ctx, :item, hd(items))
    end

    test "success", ctx do
      conn = index_path(ctx)
      assert html_response(conn, 200) =~ ctx.item.name
    end
  end

  # Routes

  defp index_path(ctx) do
    get(ctx.conn, Routes.todo_item_path(ctx.conn, :index))
  end
end
