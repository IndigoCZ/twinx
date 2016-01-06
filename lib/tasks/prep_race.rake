namespace :twinx do
  desc "Load categories and constraints from a ruleset file"
  task :prep_race => :environment do
    new_race=Race.find(7)
    ruleset_file="config/rulesets/moutnice2015.yml"
    ruleset=YAML.load_file(ruleset_file)
    Category.set_ruleset_file(ruleset_file)
    ruleset["categories"].each_key do |code|
      Category.first_or_create_by_code(new_race,code)
    end
  end
end
