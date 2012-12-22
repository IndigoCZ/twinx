# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
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
first_names=%w[Adam Bedrich Cenek Daniel Erik Filip Gilbert Hugo Ilja Jakub Karel Leopold Martin Nero Ondrej Pavel Quido Robert Stanislav Tomas Uwe Vaclav Walter Xerxes Yari Zdenek]
last_names=%w[Cech Slovak Nemec Polak Spanel Sedlak Svoboda Novotny Husak Danek Zamecnik Vymazal Hutak Chudacek Matysek Drotar]
100.times do
  Person.create(
    first_name:first_names.sample,
    last_name:last_names.sample,
    yob:1910+rand(100),
    gender:"male",
    county_id:counties.sample.id
  )
end
first_names=%w[Alena Beata Ciara Dana Eva Frantiska Gina Helena Irena Jana Klara Linda Milada Nadezda Olga Petra Quida Radka Silva Tana Ursula Viktorka Wendy Xena Yvetta Zdena]
last_names=%w[Cechova Slovakova Nemcova Polakova Spanelova Sedlakova Svobodova Novota Husakova Dankova Zamecnikova Vymazalova Hutakova Chudackova Matyskova Drotarova]
50.times do
  Person.create(
    first_name:first_names.sample,
    last_name:last_names.sample,
    yob:1910+rand(100),
    gender:"female",
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
