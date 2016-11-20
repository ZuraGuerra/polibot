defmodule Polibot.ChatView do
  use Polibot.Web, :view

  def render("challenge.json", %{challenge: challenge}), do: challenge |> String.to_integer

  def render("fb_callback.json", %{}), do: %{}
end
