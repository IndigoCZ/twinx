# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
require 'faker'

Result.delete_all
Participant.delete_all
Team.delete_all
Category.delete_all
Person.delete_all
County.delete_all
Race.delete_all

races=Race.create([
  {title:"Test XVI", held_on:3.years.ago},
  {title:"Filler", held_on:2.years.ago},
  {title:"Sample", held_on:1.year.ago}
])
counties=County.create([
  {title:"Moutnice"},
  {title:"Tesany"},
  {title:"Nesvacilka"},
  {title:"Rozarin"}
])
100.times do
  Person.create(
    first_name:Faker::Name.first_name,
    last_name:Faker::Name.last_name,
    yob:1910+rand(100),
    gender:["male","female"].sample,
    county_id:counties.sample.id
  )
end

races.each do |race|
  counties.each do |county|
    Team.create(race_id:race.id, county_id:county.id)
  end
end
races.each do |race|
  Category.create([
    {title:"Juniori",race_id:race.id},
    {title:"Seniori",race_id:race.id},
    {title:"Juniorky",race_id:race.id},
    {title:"Seniorky",race_id:race.id},
  ])
end
races.each do |race|
  Person.all.each do |person|
    Participant.create(
      starting_no:rand(998)+1,
      category_id:race.categories.sample.id,
      person_id:person.id,
      team_id:race.teams.sample.id
    )
  end
end

Participant.all.each do |participant|
  Result.create(position:rand(100),time_msec:rand(100000),participant_id:participant.id)
end
