defmodule Polibot.CandidateQueries do
  use Polibot.Web, :model
  alias Polibot.{Repo, Candidate}

  def by_fb_id(fb_id) do
    from(candidate in Candidate,
    where: candidate.fb_id == ^fb_id)
  end
end
