class DifficultyObserver < ActiveRecord::Observer
  observe :category, :constraint

  def before_validation(obj)
    case obj
    when Category
      obj.difficulty = obj.difficulty
    end
  end

  def after_save(obj)
    case obj
    when Constraint
      obj.category.update_attribute(:difficulty, obj.category.difficulty)
    end
  end
end
