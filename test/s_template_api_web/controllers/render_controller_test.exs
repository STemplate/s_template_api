defmodule STemplateApiWeb.TemplateControllerTest do
  use STemplateApiWeb.ConnCase

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "create template" do
    test "renders template when data is valid", %{conn: conn} do
      STemplateApi.Test.Factories.insert(
        :template,
        name: "some_name",
        template: "Hello: {{ user.last_name }}, {{ user.first_name }}"
      )

      conn =
        post(conn, "/api/templates/some_name/render",
          params: %{
            "user" => %{
              "first_name" => "John",
              "last_name" => "Do"
            }
          }
        )

      assert %{"data" => "Hello: Do, John"} = json_response(conn, 201)
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn =
        post(conn, "/api/templates/not_exist/render",
          params: %{
            "user" => %{
              "first_name" => "John",
              "last_name" => "Do"
            }
          }
        )

      assert json_response(conn, 404)["errors"] != %{}
    end

    test "renders errors when template is invalid", %{conn: conn} do
      STemplateApi.Test.Factories.insert(
        :template,
        name: "some_name",
        template: "Hello: {{ user}"
      )

      conn =
        post(conn, "/api/templates/some_name/render",
          params: %{
            "user" => %{
              "first_name" => "John"
            }
          }
        )

      assert json_response(conn, 422)["errors"] == %{"detail" => "Unprocessable Entity"}
    end
  end
end
