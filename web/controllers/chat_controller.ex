defmodule Polibot.ChatController do
  use Polibot.Web, :controller
  alias Polibot.{CandidateServices, MessageServices}

  @messages_url "https://graph.facebook.com/v2.6/me/messages?access_token=" <> System.get_env("POLIBOT_FB_TOKEN")

  # First interaction with the player
  def chat(conn, %{"entry" => [%{"messaging" => [%{"postback" => %{"payload" => "Let's run for presidency!"},
                                                   "recipient" => %{"id" => page_id},
                                                   "sender" => %{"id" => user_id}}|_]}|_]}) do
    candidate = CandidateServices.create!(user_id)
    avatar_url = CandidateServices.get_avatar(candidate)

    # Send avatar
    avatar_message = MessageServices.image(candidate.fb_id, avatar_url) |> Poison.encode!
    HTTPotion.post!(@messages_url, [body: avatar_message, status_code: 200,
                                   headers: ["Content-Type": "application/json"]])
    # Send background story
    background_story = CandidateServices.generate_story(candidate)
    buttons = [MessageServices.postback_button("View my stats", "View my stats")]
    background_message = MessageServices.button_template(candidate.fb_id, background_story, buttons) |> Poison.encode!
    HTTPotion.post!(@messages_url, [body: background_message, status_code: 200,
                                    headers: ["Content-Type": "application/json"]])
    render conn, "fb_callback.json"
  end

  # Check player stats
  def chat(conn, %{"entry" => [%{"messaging" => [%{"postback" => %{"payload" => "View my stats"},
                                                   "recipient" => %{"id" => page_id},
                                                   "sender" => %{"id" => user_id}}|_]}|_]}) do
    candidate = CandidateQueries.by_fb_id!(user_id)

    # Send politic stats title
    stats_title = "https://github.com/ZuraGuerra/polibot/raw/master/web/static/images/political-stats.jpg"
    stats_message = MessageServices.image(candidate.fb_id, stats_title) |> Poison.encode!
    HTTPotion.post!(@messages_url, [body: stats_message, status_code: 200,
                                  headers: ["Content-Type": "application/json"]])
    # Send background story
    background_story = CandidateServices.generate_story(candidate)
    buttons = [MessageServices.postback_button("View my stats", "View my stats")]
    background_message = MessageServices.button_template(candidate.fb_id, background_story, buttons) |> Poison.encode!
    HTTPotion.post!(@messages_url, [body: background_message, status_code: 200,
                                   headers: ["Content-Type": "application/json"]])
    render conn, "fb_callback.json"
  end

  def chat(conn, %{"entry" => [%{"messaging" => [%{"message" => %{"text" => text}}|_]}|_]}) do
    IO.puts text
    render conn, "fb_callback.json"
  end

  # Callback
  def chat(conn, %{"object" => "page"}) do
    render conn, "fb_callback.json"
  end

  # Verify webhook
  def chat(conn, %{"hub.challenge" => challenge}),
    do: render conn, "challenge.json", challenge: challenge
end
