defmodule STemplateApiWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use STemplateApiWeb, :controller

  # This clause handles errors returned by Ecto's insert/update/delete.
  def call(conn, {:error, %Ecto.Changeset{} = changeset}) do
    conn
    |> put_status(:unprocessable_entity)
    |> put_view(STemplateApiWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  # This clause is an example of how to handle resources that cannot be found.
  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(:not_found)
    |> put_view(STemplateApiWeb.ErrorView)
    |> render(:"404")
  end

  def call(conn, {:error, "Template not found"}), do: call(conn, {:error, :not_found})

  def call(conn, {:error, msg}) do
    conn
    |> put_status(422)
    |> put_view(STemplateApiWeb.ErrorView)
    |> render(:"422.json", msg: msg)
  end
end
