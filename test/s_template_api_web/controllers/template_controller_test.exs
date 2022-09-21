defmodule STemplateApiWeb.TemplateControllerTest do
  use STemplateApiWeb.ConnCase

  import STemplateApi.TemplatingFixtures

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all templates", %{conn: conn} do
      conn = get(conn, Routes.template_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "show" do
    test "get 1 template", %{conn: conn} do
      template = template_fixture()
      conn = get(conn, "/api/templates/#{template.name}")

      assert json_response(conn, 200)["data"] ==
               Map.from_struct(template)
               |> Map.take([:enabled, :id, :labels, :template, :version, :name])
               |> STemplateApi.Map.Helpers.stringify_keys()
    end

    test "get 1 template by name and version", %{conn: conn} do
      template = template_fixture()
      conn = get(conn, "/api/templates/#{template.name}?version=#{template.version}")

      assert json_response(conn, 200)["data"] ==
               Map.from_struct(template)
               |> Map.take([:enabled, :id, :labels, :template, :version, :name])
               |> STemplateApi.Map.Helpers.stringify_keys()
    end
  end

  describe "create template" do
    test "renders template when data is valid", %{conn: conn} do
      conn =
        post(conn, "/api/templates",
          template: %{
            labels: [],
            name: "some_name",
            template: "some template"
          }
        )

      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, "/api/templates/some_name")

      assert %{
               "id" => ^id,
               "enabled" => true,
               "labels" => [],
               "name" => "some_name",
               "template" => "some template",
               "version" => 1
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, "/api/templates",
          template: %{
            labels: [],
            name: "some_name"
          }
        )

      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete template" do
    setup [:create_template]

    test "deletes chosen template", %{conn: conn, template: template} do
      conn = delete(conn, "/api/templates/#{template.name}")
      assert response(conn, 204)
    end
  end

  defp create_template(_) do
    template = template_fixture()
    %{template: template}
  end
end
