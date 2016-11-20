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
end
