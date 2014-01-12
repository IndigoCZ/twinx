namespace :twinx do
  desc "List stats for current race"
  task :stats => :environment do
    race=Race.last
    puts race.participants.count
    %w[mladší starší].each do |order|
      %w[male female].each do |gender|
        if order=="mladší"
          nej=race.participants.includes(:person).where("people.gender='#{gender}' AND people.born IS NOT NULL").order("people.born DESC").first
        else
          nej=race.participants.includes(:person).where("people.gender='#{gender}'").order("people.born").first
        end
        if gender=="male"
          puts "Nej#{order} muž:"
        else
          puts "Nej#{order} žena:"
        end
        puts "#{nej.starting_no} #{nej.person.display_name} #{nej.person.born}"
      end
    end
  end
end
