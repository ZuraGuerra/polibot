defmodule Polibot.MessageServices do
  def image(recipient_id, image_url) do
    %{
      "recipient" => %{
        "id" => recipient_id
      },
      "message" => %{
        "attachment" => %{
          "type" => "image",
          "payload" => %{
            "url" => image_url
          }
        }
      }
    }
  end

  def button_template(recipient_id, text, buttons) do
    %{
      "recipient" => %{
        "id" => recipient_id
      },
      "message" => %{
        "attachment" => %{
          "type" => "template",
          "payload" => %{
            "template_type" => "button",
            "text" => text,
            "buttons" => buttons
          }
        }
      }
    }
  end

  def url_button(url, title) do
    %{
      "type" => "web_url",
      "url" => url,
      "title" => title
    }
  end

  def postback_button(payload, title) do
    %{
      "type" => "postback",
      "title" => title,
      "payload" => payload
    }
  end
end
