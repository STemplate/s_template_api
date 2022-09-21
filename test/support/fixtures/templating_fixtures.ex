defmodule STemplateApi.TemplatingFixtures do
  @moduledoc false

  @doc false
  def template_fixture(attrs \\ %{}) do
    {:ok, template} =
      attrs
      |> Enum.into(%{
        "enabled" => true,
        "labels" => [],
        "name" => "some_name",
        "template" => "some template"
      })
      |> STemplateApi.Templating.create_template()

    template
  end
end
