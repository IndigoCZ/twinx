# encoding: UTF-8
module ModelDependencyHandling
  def block_deletion_on_dependency(*list_of_dependencies)
    define_method(:check_blocking_dependencies) do
      rval=true
      list_of_dependencies.each do |dep|
        if self.send(dep).count > 0
          errors.add(:base, "cannot be deleted while #{dep} exist")
          rval=false
        end
      end
      rval
    end
    before_destroy :check_blocking_dependencies
  end
end
