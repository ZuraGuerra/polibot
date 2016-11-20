defmodule Polibot.ChatController do
  use Polibot.Web, :controller
  alias Polibot.{CandidateServices, CandidateQueries, CountryServices,
                 MessageServices, Repo, Country, StateServices, TweeterServices}

  @messages_url "https://graph.facebook.com/v2.6/me/messages?access_token=" <> System.get_env("POLIBOT_FB_TOKEN")
  @magi_tweeter_url System.get_env("MAGI_TWEETER_URL")

  # Candidate background info
  def chat(conn, %{"entry" => [%{"messaging" => [%{"postback" => %{"payload" => "Let's start!"},
                                                   "recipient" => %{"id" => page_id},
                                                   "sender" => %{"id" => user_id}}|_]}|_]}) do
    # Send intro
    intro = "Hello! I'm your campaign assistant. Do you want me to remember you the details of your presidential race?"
    buttons = [MessageServices.postback_button("Sure, please", "Sure, please")]
    background_message = MessageServices.button_template(user_id, intro, buttons) |> Poison.encode!
    HTTPotion.post!(@messages_url, [body: background_message, status_code: 200,
                                   headers: ["Content-Type": "application/json"]])
    render conn, "fb_callback.json"
  end

  # Candidate background info
  def chat(conn, %{"entry" => [%{"messaging" => [%{"postback" => %{"payload" => "Sure, please"},
                                                   "recipient" => %{"id" => page_id},
                                                   "sender" => %{"id" => user_id}}|_]}|_]}) do
    country = CountryServices.create!
    {states, _} = StateServices.create_many!(country, 4)
    candidate = CandidateServices.create!(user_id, country)
    avatar_url = CandidateServices.get_avatar(candidate)

    # Send avatar
    avatar_message = MessageServices.image(candidate.fb_id, avatar_url) |> Poison.encode!
    HTTPotion.post!(@messages_url, [body: avatar_message, status_code: 200,
                                    headers: ["Content-Type": "application/json"]])
    # Send background story
    background_story = CandidateServices.generate_story(candidate)
    buttons = [MessageServices.postback_button("My ratings?", "My ratings?")]
    background_message = MessageServices.button_template(candidate.fb_id, background_story, buttons) |> Poison.encode!
    HTTPotion.post!(@messages_url, [body: background_message, status_code: 200,
                                    headers: ["Content-Type": "application/json"]])
    render conn, "fb_callback.json"
  end

  # Check player stats
  def chat(conn, %{"entry" => [%{"messaging" => [%{"postback" => %{"payload" => "My ratings?"},
                                                   "recipient" => %{"id" => page_id},
                                                   "sender" => %{"id" => user_id}}|_]}|_]}) do
    candidate = CandidateQueries.by_fb_id(user_id) |> Repo.one!

    # Send politic stats title
    stats_title = "https://github.com/ZuraGuerra/polibot/raw/master/web/static/images/presidential-stats.jpg"
    stats_message = MessageServices.image(candidate.fb_id, stats_title) |> Poison.encode!
    HTTPotion.post!(@messages_url, [body: stats_message, status_code: 200, headers: ["Content-Type": "application/json"]])
    # Send politic stats
    stats = CandidateServices.generate_stats(candidate)
    stats_message = MessageServices.text(candidate.fb_id, stats) |> Poison.encode!
    HTTPotion.post!(@messages_url, [body: stats_message, status_code: 200,
                                    headers: ["Content-Type": "application/json"]])
    # Invite to see country stats
    invite = "We live in a beautiful country. Do you want me to show you the map?"
    buttons = [MessageServices.postback_button("Let's see", "Let's see")]
    background_message = MessageServices.button_template(candidate.fb_id, invite, buttons) |> Poison.encode!
    HTTPotion.post!(@messages_url, [body: background_message, status_code: 200,
                                    headers: ["Content-Type": "application/json"]])
    render conn, "fb_callback.json"
  end

  # Check player's country
  def chat(conn, %{"entry" => [%{"messaging" => [%{"postback" => %{"payload" => "Let's see"},
                                                   "recipient" => %{"id" => page_id},
                                                   "sender" => %{"id" => user_id}}|_]}|_]}) do
    # Show country's map
    candidate = CandidateQueries.by_fb_id(user_id) |> Repo.one!
    country = Repo.get!(Country, candidate.country_id)
    country_map = CountryServices.map_url(country)
    map_message = MessageServices.image(candidate.fb_id, country_map) |> Poison.encode!
    HTTPotion.post!(@messages_url, [body: map_message, status_code: 200,
                                    headers: ["Content-Type": "application/json"]])
    # Invite to see country stats
    country_story = CountryServices.story(country)
    buttons = [MessageServices.postback_button("Show infographic", "Show infographic")]
    story_message = MessageServices.button_template(candidate.fb_id, country_story, buttons) |> Poison.encode!
    HTTPotion.post!(@messages_url, [body: story_message, status_code: 200,
                                    headers: ["Content-Type": "application/json"]])
    render conn, "fb_callback.json"
  end

  # Show country stats
  def chat(conn, %{"entry" => [%{"messaging" => [%{"postback" => %{"payload" => "Show infographic"},
                                                   "recipient" => %{"id" => page_id},
                                                   "sender" => %{"id" => user_id}}|_]}|_]}) do
    candidate = CandidateQueries.by_fb_id(user_id) |> Repo.one!
    country = Repo.get!(Country, candidate.country_id)
    # Send politic stats title
    stats_title = "https://github.com/ZuraGuerra/polibot/raw/master/web/static/images/country-stats.jpg"
    stats_message = MessageServices.image(candidate.fb_id, stats_title) |> Poison.encode!
    HTTPotion.post!(@messages_url, [body: stats_message, status_code: 200, headers: ["Content-Type": "application/json"]])
    # Send country stats
    stats = CountryServices.calculate_stats(country)
    stats_message = MessageServices.text(candidate.fb_id, stats) |> Poison.encode!
    HTTPotion.post!(@messages_url, [body: stats_message, status_code: 200,
                                    headers: ["Content-Type": "application/json"]])
    # Invite to begin campaign!
    invite = "Are you ready to start your campaign?"
    buttons = [MessageServices.postback_button("Yeah, I'm ready!", "Yeah, I'm ready!")]
    invite_message = MessageServices.button_template(candidate.fb_id, invite, buttons) |> Poison.encode!
    HTTPotion.post!(@messages_url, [body: invite_message, status_code: 200,
                                    headers: ["Content-Type": "application/json"]])
    render conn, "fb_callback.json"
  end

  # Begin campaign, yaaay!
  def chat(conn, %{"entry" => [%{"messaging" => [%{"postback" => %{"payload" => "Yeah, I'm ready!"},
                                                   "recipient" => %{"id" => page_id},
                                                   "sender" => %{"id" => user_id}}|_]}|_]}) do
    candidate = CandidateQueries.by_fb_id(user_id) |> Repo.one!
    country = Repo.get!(Country, candidate.country_id)
    # Tweet campaign beginning
    tweet = TweeterServices.start_campaign(candidate) |> Poison.encode!
    HTTPotion.post!(@magi_tweeter_url, [body: tweet, status_code: 200, headers: ["Content-Type": "application/json"]])
    # Sent Talisman NEWS Twitter to candidate
    talisman_invite = "Congrats! Remember that the global chain Talisman NEWS will be covering every move of your campaign."
    buttons = [MessageServices.url_button("https://twitter.com/talismanNewsGJ", "Check Talisman NEWS")]
    invite_message = MessageServices.button_template(candidate.fb_id, talisman_invite, buttons) |> Poison.encode!
    HTTPotion.post!(@messages_url, [body: invite_message, status_code: 200,
                                    headers: ["Content-Type": "application/json"]])
    render conn, "fb_callback.json"
  end

  # Reset game
  def chat(conn, %{"entry" => [%{"messaging" => [%{"postback" => %{"payload" => "Reset"},
                                                   "recipient" => %{"id" => page_id},
                                                   "sender" => %{"id" => user_id}}|_]}|_]}) do
    # Delete candidate
    CandidateQueries.by_fb_id(user_id) |> Repo.one! |> Repo.delete!
    # Ask to delete conversation
    invite = "To fully restart the game, please delete this conversation and talk to me again. Thanks for playing The Assistant 🏁 🎉"
    deletion_message = MessageServices.text(user_id, invite) |> Poison.encode!
    HTTPotion.post!(@messages_url, [body: deletion_message, status_code: 200,
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
