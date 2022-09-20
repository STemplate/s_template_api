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
