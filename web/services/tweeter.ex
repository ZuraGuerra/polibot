defmodule Polibot.TweeterServices do
  def start_campaign(candidate) do
    %{
      "action" => "startCampaign",
      "name" => "#{candidate.first_name} #{candidate.last_name}"
    }
  end
end
