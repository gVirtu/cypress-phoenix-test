defmodule App.Repo.Migrations.AddTodoItems do
  use Ecto.Migration

  def change do
    create table(:todo_items) do
      add :name, :string, null: false
      add :description, :text
      add :completed_at, :utc_datetime_usec

      timestamps()
    end
  end
end
