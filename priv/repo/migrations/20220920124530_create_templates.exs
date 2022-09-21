defmodule STemplateApi.Repo.Migrations.CreateTemplates do
  use Ecto.Migration

  def change do
    create table(:templates, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :template, :string, null: false
      add :version, :integer, null: false, default: 1
      add :enabled, :boolean, default: false, null: false
      add :labels, {:array, :string}, default: [], null: false

      timestamps()
    end

    create unique_index(:templates, [:name, :version])
  end
end
