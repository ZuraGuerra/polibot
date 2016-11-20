defmodule Polibot.InfoServices do
  @races ["Latino", "White", "Asian", "Black"]
  @genders ["Female", "Male"]
  @tendencies ["Liberalism", "Conservatism"]
  @last_names ["Zhou", "Lee", "Deschamps", "Lewis", "Ochoa", "Riviera", "Miller"]
  @female_first_names ["Laura", "Janina", "Bonita", "María", "Katherine", "Yoon", "Cindy", "Qiu"]
  @male_first_names ["John", "George", "Raul", "Pedro", "Goro", "Ichirou", "Ade", "Fatou"]
  @state_names ["Ance", "Bora", "Yamahina", "Poola", "Reij", "Anchara", "Xi", "Govinda", "Biou"]
  @religions ["Buddhism", "Christianism", "Sikhism", "Ateism", "Voodoo", "Protestantism"]

  def assign_random(:race) do
    [race] = Enum.take_random(@races, 1)
    race
  end

  def assign_random(:religion) do
    [religion] = Enum.take_random(@religions, 1)
    religion
  end

  def assign_random(:state_name) do
    [name] = Enum.take_random(@state_names, 1)
    name
  end

  def assign_random(:gender) do
    [gender] = Enum.take_random(@genders, 1)
    gender
  end

  def assign_random(:tendency) do
    [tendency] = Enum.take_random(@tendencies, 1)
    tendency
  end

  def assign_random(:last_name) do
    [last_name] = Enum.take_random(@last_names, 1)
    last_name
  end

  def assign_random(:first_name, %{gender: "Female"}) do
    [first_name] = Enum.take_random(@female_first_names, 1)
    first_name
  end

  def assign_random(:first_name, %{gender: "Male"}) do
    [first_name] = Enum.take_random(@male_first_names, 1)
    first_name
  end

  def generate_boolean_state do
    [state] = Enum.take_random([true, false], 1)
    state
  end

  def generate_random_percentage(lower, higher) do
    [percentage] = Enum.take_random(lower..higher, 1)
    percentage
  end

  def generate_random_number(zeros) do
    digits = :math.pow(10, zeros) |> round
    min = :math.pow(10, (zeros - 1)) |> round
    random = :random.uniform * digits |> round
    cond do
      random < min -> random * 10
      :else -> random
    end
  end
end
