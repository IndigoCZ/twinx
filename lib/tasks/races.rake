namespace :twinx do
  desc "Show details about all races"
  task :races => :environment do
    Race.order(:held_on).all.each do |race|
      puts "#{race.id} #{race.held_on} #{race.short_name} #{race.participants.count} #{race.title}"
    end
  end
end

