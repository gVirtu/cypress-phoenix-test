defmodule App.Factory do
  use ExMachina.Ecto, repo: App.Repo

  def todo_item_factory do
    %App.Todos.TodoItem{
      name: sequence(:name, &"Task #{&1}"),
      description: sequence(:description, &"Description of task #{&1}"),
    }
  end
end
