defmodule STemplateApiWeb.TemplateController do
  @moduledoc false

  use STemplateApiWeb, :controller

  alias STemplateApi.Templating
  alias STemplateApi.Templating.Template

  action_fallback STemplateApiWeb.FallbackController

  def index(conn, _params) do
    templates = Templating.list_templates()
    render(conn, "index.json", templates: templates)
  end

  def create(conn, %{"template" => template_params}) do
    with {:ok, %Template{} = template} <- Templating.create_template(template_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", Routes.template_path(conn, :show, template))
      |> render("show.json", template: template)
    end
  end

  def show(conn, %{"name" => name, "version" => version}) do
    template = Templating.get_template(name, version)
    render(conn, "show.json", template: template)
  end

  def show(conn, %{"name" => name}) do
    template = Templating.get_template(name)
    render(conn, "show.json", template: template)
  end

  def delete(conn, %{"name" => name}) do
    with {:ok, %Template{}} <- Templating.delete_template(name) do
      send_resp(conn, :no_content, "")
    end
  end
end
