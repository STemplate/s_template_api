require STemplateApi.Templating.Template

{:ok, _} = Application.ensure_all_started(:ex_machina)

ExUnit.start()
Faker.start()

Ecto.Adapters.SQL.Sandbox.mode(STemplateApi.Repo, :manual)
