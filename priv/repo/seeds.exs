# Version 1
Templating.create_template(%{
  name: "cool_template",
  template: "That's my secret {{ hero.name }}: I'm always angry."
})

# Version 2
Templating.create_template(%{
  name: "cool_template",
  template: "That's my secret {{ hero.name }}: I'm always angry!!!"
})
