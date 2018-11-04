FactoryBot.define do
  sequence :name do |n|
    "bootcamp_#{n}"
  end

  factory :bootcamp do
    name
    year_founded 2018
    active true
    languages ['Ruby', 'JavaScript']
    full_time_tuition_cost 10000
    part_time_tuition_cost 5000
  end
end