defmodule STemplateApiWeb.RenderController do
  @moduledoc false

  use STemplateApiWeb, :controller

  alias Liquid.Render

  action_fallback STemplateApiWeb.FallbackController

  def create(conn, %{
        "template_name" => name,
        "params" => params
      }) do
    with {:ok, result} <- Liquid.Render.call(name, params) do
      conn
      |> put_status(:created)
      |> json(%{
        data: result
      })
    end
  end
end
