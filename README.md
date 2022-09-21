# STemplateApi

Simple ..., String ... , Super?
Liquid strings templates by API.

## Model

```mermaid
erDiagram

    template {
        character_varying name
        character_varying template
        int version
        bool enabled
        array labels
    }

    email_template {
        character_varying name
        character_varying subject_template
        character_varying body_template
        int version
        bool enabled
        array labels
    }
    
    generated_files {
        character_varying name
        character_varying type
        uuid template_id
        character_varying url
    }
    
    template ||--o{ generated_files : "template_id"
```

## Examples

```txt
That's my secret {{ hero.name }}: I'm always angry.
```

```json
{
  "hero": {
    "name": "Captain"
  }
}
```
## Cleaning code

```shell
mix setup
mix test

mix format # format code
mix credo # like rubocop
mix coveralls.html # code coverage
mix deps.audit # libraries vulnerabilities check
mix sobelow # security static code check
mix dialyzer # static analysis tool for Erlang
mix docs # gen doc

mix phx.server
open http://localhost:4000/api/movies
```

## Routes

```shell
# simplified routes
mix phx.routes | grep '/api' | awk '{print $2 " " $3}' | sed '/.*Controller/d'

# seed some data
mix run priv/repo/seeds.exs
