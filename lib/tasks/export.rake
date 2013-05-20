require 'csv_interface'
namespace :twinx do
  desc "Export participants for all races"
  task :export => :environment do
    Race.all.each do |race|
      File.open("export/#{race.short_name}.csv","w+") do |file|
        file<<CSVInterface.export(race.participants,%w[starting_no first_name last_name full_name gender yob team category position time born id_string])
      end
    end
  end
end
