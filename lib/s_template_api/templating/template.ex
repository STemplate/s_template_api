defmodule STemplateApi.Templating.Template do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "templates" do
    field :enabled, :boolean, default: false
    field :labels, {:array, :string}
    field :name, :string
    field :template, :string
    field :version, :integer

    timestamps()
  end

  @doc false
  def changeset(template, attrs) do
    template
    |> cast(attrs, [:name, :template, :version, :enabled, :labels])
    |> validate_required([:name, :template, :version])
  end
end
