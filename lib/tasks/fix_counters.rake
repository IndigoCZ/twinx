namespace :twinx do
  desc "Fix category and team counters"
  task :fix_counters => :environment do
    race=Race.last
    puts race.inspect
    race.categories.each do |cat|
      Category.reset_counters(cat.id, :participants)
      putc "C"
    end
    race.teams.each do |team|
      Team.reset_counters(team.id, :participants)
      putc "T"
    end
  end
end
