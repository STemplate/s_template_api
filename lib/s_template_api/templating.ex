defmodule STemplateApi.Templating do
  @moduledoc """
    The Templating context have all the functionality to generate and transform templates.
    Types:
      - Template (any string one)
      - EmailTemplate (like template but with subject)
  """

  import Ecto.Query, warn: false
  alias STemplateApi.Repo
  alias STemplateApi.Templating.Template

  @doc """
  Creates a template.

  ## Examples

      iex> Templating.create_template(%{name: "cool_template", template: "hello kitty"})
      {:ok, %Template{}}

      iex> Templating.create_template(%{version: -1})
      {:error, %Ecto.Changeset{}}

  """
  def create_template(%{name: name} = attrs) do
    # TODO: move logic to Template!
    query =
      from t in Template,
        where: ilike(t.name, ^name),
        order_by: {:desc, :version},
        limit: 1

    version =
      case query |> Repo.one() do
        nil ->
          1

        last ->
          if last.template == attrs[:template] do
            raise "Same template than last version"
          end

          last.version + 1
      end

    %Template{}
    |> Template.changeset(Map.merge(attrs, %{version: version, enabled: true}))
    |> Repo.insert()
  end

  @doc """
  Returns the list of templates with the last version.

  ## Examples

      iex> Templating.list_templates()
      [%Template{}, ...]
  """
  def list_templates do
    query =
      from t in Template,
        where: t.enabled,
        group_by: t.name,
        select: {t.name, max(t.version)}

    query |> Repo.all()
  end

  @doc """
  Get the last version of a template by name.

  ## Examples

      iex> Templating.get_template("cool_template")
      %Template{}

      iex> Templating.get_template("not_exist")
      nil
  """
  def get_template(name) do
    from(t in Template,
      where: ilike(t.name, ^name) and t.enabled,
      order_by: {:desc, :version},
      limit: 1
    )
    |> Repo.one()
  end

  @doc """
  Get the a template by name and version.

  ## Examples

      iex> Templating.get_template("cool_template", 2)
      %Template{}

      iex> Templating.get_template("not_exist", 2)
      nil
  """
  def get_template(name, version) do
    from(t in Template,
      where:
        ilike(t.name, ^name) and
          t.version == ^version and
          t.enabled,
      limit: 1
    )
    |> Repo.one()
  end

  @doc """
  Deletes a template by name and version.

  ## Examples

      iex> Templating.delete_template("cool_template", 2)
      {:ok, %Template{}}
      {:error, %Ecto.Changeset{}}
  """
  def delete_template(name) do
    get_template(name)
    |> Template.changeset(%{enabled: false})
    |> Repo.update()
  end
end
