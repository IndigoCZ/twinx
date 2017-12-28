namespace :twinx do
  desc "List stats for current race"
  task :stats => :environment do
    race=Race.last
    puts race.participants.count
    %w[mladší starší].each do |order|
      %w[male female].each do |gender|
        if order=="mladší"
          nej=race.participants.includes(:person).where("people.gender='#{gender}'").order("people.yob DESC").order("people.born DESC").first
        else
          nej=race.participants.includes(:person).where("people.gender='#{gender}'").order("people.yob").order("people.born").first
        end
        if gender=="male"
          puts "Nej#{order} muž:"
        else
          puts "Nej#{order} žena:"
        end
        if nej
          puts "#{nej.starting_no} #{nej.person.display_name} #{nej.person.yob} #{nej.person.born}"
        else
          puts "N/A"
        end
      end
    end
  end
end
