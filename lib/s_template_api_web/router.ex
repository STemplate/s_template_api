defmodule STemplateApiWeb.Router do
  use STemplateApiWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", STemplateApiWeb do
    pipe_through :api

    resources "/templates", TemplateController, except: [:edit, :update], param: "name" do
      resources "/render", RenderController, only: [:create]
    end
  end

  if Mix.env() in [:dev, :test] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through [:fetch_session, :protect_from_forgery]

      live_dashboard "/dashboard", metrics: STemplateApiWeb.Telemetry
    end
  end

  if Mix.env() == :dev do
    scope "/dev" do
      pipe_through [:fetch_session, :protect_from_forgery]

      forward "/mailbox", Plug.Swoosh.MailboxPreview
    end
  end
end
