defmodule STemplateApi.TemplatingTest do
  use STemplateApi.DataCase

  alias STemplateApi.Templating

  describe "templates" do
    alias STemplateApi.Templating.Template

    import STemplateApi.TemplatingFixtures

    test "create_template/1 with valid data creates a template" do
      assert {:ok, %Template{} = template} =
               Templating.create_template(%{
                 "labels" => ["pdf", "liquid"],
                 "name" => "some_name",
                 "template" => "some template {{ var }}"
               })

      assert template.enabled == true
      assert template.labels == ["pdf", "liquid"]
      assert template.name == "some_name"
      assert template.template == "some template {{ var }}"
      assert template.version == 1

      assert {:ok, %Template{} = template} =
               Templating.create_template(%{
                 "labels" => ["pdf", "liquid"],
                 "name" => "some_name",
                 "template" => "some template {{ var }}2"
               })

      assert template.enabled == true
      assert template.labels == ["pdf", "liquid"]
      assert template.name == "some_name"
      assert template.template == "some template {{ var }}2"
      assert template.version == 2

      assert_raise RuntimeError, "Same template than last version", fn ->
        Templating.create_template(%{
          "labels" => ["pdf", "liquid"],
          "name" => "some_name",
          "template" => "some template {{ var }}2"
        })
      end
    end

    test "create_template/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Templating.create_template(%{
                 "labels" => nil,
                 "enabled" => nil,
                 "name" => nil,
                 "template" => nil,
                 "version" => nil
               })
    end

    test "list_templates/0 returns all templates" do
      template_fixture()
      assert Templating.list_templates() == [{"some_name", 1}]
    end

    test "get_template/1 returns the template with given name" do
      template = template_fixture()
      assert Templating.get_template(template.name) == template
    end

    test "get_template/2 returns the template with given name and version" do
      template = template_fixture()
      assert Templating.get_template(template.name, template.version) == template
    end

    test "delete_template/1 deletes the template" do
      template = template_fixture()
      assert {:ok, %Template{}} = Templating.delete_template(template.name)
      assert nil == Templating.get_template(template.name)
    end
  end
end
