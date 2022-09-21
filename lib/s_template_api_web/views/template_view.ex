defmodule STemplateApiWeb.TemplateView do
  use STemplateApiWeb, :view
  alias STemplateApiWeb.TemplateView

  def render("index.json", %{templates: templates}) do
    %{data: render_many(templates, TemplateView, "template.json")}
  end

  def render("show.json", %{template: template}) do
    %{data: render_one(template, TemplateView, "template.json")}
  end

  def render("template.json", %{template: template}) do
    %{
      id: template.id,
      name: template.name,
      template: template.template,
      version: template.version,
      enabled: template.enabled,
      labels: template.labels
    }
  end
end
