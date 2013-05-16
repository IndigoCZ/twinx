class CategoryPicker
  attr_reader :categories
  def initialize(categories)
    @categories=categories
  end
  def pick(options)
    age=options[:age]
    age||=(Time.now.year - options[:yob].to_i)
    @categories.select do |cat|
      category_constraint_fits_gender_or_age(cat,options[:gender],age)
    end.sort_by(&:difficulty).reverse
  end
  def category_constraint_fits_gender_or_age(category,gender,age)
    category.constraints.each do |con|
      case con.restrict
      when "gender"
        return false unless con.value==gender
      when "min_age"
        return false unless con.value<=age
      when "max_age"
        return false unless con.value>=age
      end
    end
  end
end
