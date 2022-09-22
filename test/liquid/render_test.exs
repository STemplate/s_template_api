defmodule Liquid.RenderTest do
  @moduledoc false

  use ExUnit.Case
  use STemplateApi.DataCase

  alias Liquid.Render

  describe "parse" do
    test "not found" do
      STemplateApi.Test.Factories.insert(:template, %{name: "abc", template: "hello there"})

      assert {:error, result} = Render.call("different", nil)
      assert result == "Template not found"
    end

    test "simple success" do
      template = STemplateApi.Test.Factories.insert(:template, template: "hello there")

      assert {:ok, result} = Render.call(template.name, nil)
      assert result == "hello there"
    end

    test "simple replace success" do
      template = STemplateApi.Test.Factories.insert(:template, template: "{{ something }} there")

      assert {:ok, result} = Render.call(template.name, %{"something" => "aló"})
      assert result == "aló there"
    end

    test "complex replace success" do
      template =
        STemplateApi.Test.Factories.insert(
          :template,
          template: "Hello: {{ user.last_name }}, {{ user.first_name }}"
        )

      assert {:ok, result} =
               Liquid.Render.call(
                 template.name,
                 %{
                   "user" => %{
                     "first_name" => "John",
                     "last_name" => "Do"
                   }
                 }
               )

      assert result == "Hello: Do, John"
    end

    test "invalid template" do
      template = STemplateApi.Test.Factories.insert(:template, template: "{{ somethin there")

      assert {:error, "Reason: expected end of string, line: 1"} =
               Liquid.Render.call(template.name, %{"a" => "aló"})
    end
  end
end
