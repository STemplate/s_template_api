defmodule STemplateApi.Test.Factories do
  @moduledoc false

  use ExMachina.Ecto, repo: STemplateApi.Repo

  def template_factory do
    %STemplateApi.Templating.Template{
      name: Faker.Food.dish() |> Recase.to_snake(),
      template: Faker.Lorem.sentence() <> " {{ something }}",
      labels: ["hardcoded", Faker.Lorem.word()],
      version: 1,
      enabled: true
    }
  end
end
