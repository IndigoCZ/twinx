class CategoryPicker
  def self.pick(race,options)
    if options.has_key? :age
      race.categories.for_gender(options[:gender]).for_age(options[:age])
    else
      race.categories.for_gender(options[:gender])
    end
  end
end
