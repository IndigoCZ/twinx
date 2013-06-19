# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
require 'faker'

Result.delete_all
Participant.delete_all
Team.delete_all
Constraint.delete_all
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
40.times do
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
    Team.create(race_id:race.id, county_id:county.id, title:county.title)
  end
end
races.each do |race|
  Category.create(title:"Juniori",race_id:race.id,sort_order:1)
  Constraint.create(restrict:"gender",string_value:"male",category_id:Category.last.id)
  Constraint.create(restrict:"max_age",integer_value:16,category_id:Category.last.id)
  Category.create(title:"Muzi",race_id:race.id,sort_order:2)
  Constraint.create(restrict:"gender",string_value:"male",category_id:Category.last.id)
  Category.create(title:"Seniori",race_id:race.id,sort_order:3)
  Constraint.create(restrict:"gender",string_value:"male",category_id:Category.last.id)
  Constraint.create(restrict:"min_age",integer_value:60,category_id:Category.last.id)
  Category.create(title:"Juniorky",race_id:race.id,sort_order:4)
  Constraint.create(restrict:"gender",string_value:"female",category_id:Category.last.id)
  Constraint.create(restrict:"max_age",integer_value:16,category_id:Category.last.id)
  Category.create(title:"Zeny",race_id:race.id,sort_order:5)
  Constraint.create(restrict:"gender",string_value:"female",category_id:Category.last.id)
  Category.create(title:"Seniorky",race_id:race.id,sort_order:6)
  Constraint.create(restrict:"gender",string_value:"female",category_id:Category.last.id)
  Constraint.create(restrict:"min_age",integer_value:60,category_id:Category.last.id)
end
races.each do |race|
  Person.all.each_with_index do |person,index|
    Participant.create(
      starting_no:(index+1),
      category_id:race.categories.sample.id,
      person_id:person.id,
      team_id:race.teams.sample.id
    )
  end
end

Category.all.each do |category|
  last_time=rand(100000)+30000
  category.participants.to_a.shuffle.each_with_index do |participant,index|
    split=last_time+rand(10000)
    time={}
    time["fract"]=(split % 1000).to_s
    time["sec"]=((split / 1000) % 60).to_s
    time["min"]=(split / 60000).to_s
    Result.create!(position:index+1,time:time,participant_id:participant.id)
    last_time=split
  end
end
