namespace :twinx do
  desc "Best results in main category"
  task :best_main_results => :environment do
    Race.all.each do |race|
      main_category=Category.first_or_create_by_code(race,"M")
      puts main_category.results.first.time
    end
  end
end
