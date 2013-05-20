namespace :twinx do
  desc "Export participants for all races"
  task :races => :environment do
    Race.order(:held_on).all.each do |race|
      puts "#{race.held_on} #{race.short_name} #{race.title}"
    end
  end
end

