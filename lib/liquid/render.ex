defmodule Liquid.Render do
  @moduledoc """
    Render a template by name with the params
  """

  @doc """
    Exec the parser and transform

    # Example

    iex> Render.call("some_template", %{ "user" => %{ "name" => "john"}})
  """
  def call(name, params) do
    case STemplateApi.Templating.get_template(name) do
      nil -> {:error, "Template not found"}
      result -> result |> render!(params)
    end
  end

  defp render!(template, nil), do: {:ok, template.template}

  defp render!(template, params) do
    case Solid.parse(template.template) do
      {:ok, text} ->
        result =
          text
          |> Solid.render!(params)
          |> to_string

        {:ok, result}

      {:error, %Solid.TemplateError{message: msg}} ->
        {:error, msg}
    end
  end
end
