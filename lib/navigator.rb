class Navigator
  def initialize(navigation_params)
    @params=navigation_params.dup
  end
  def sort_by
    @params.fetch(:rsort) do
      @params.fetch(:sort) {"default"}
    end
  end
  def group_by
    @params.fetch(:group) {false}
  end
  def filter_by
    @params.fetch(:filter) {false}
  end
  def search
    @params.fetch(:search) {false}
  end
  def reverse_sort
    @params.has_key?(:rsort)
  end
  def group_sort_and_filter(klass,things)
    things=things.order("#{klass.sort_by(group_by)} ASC") if group_by
    things=things.filter_by(filter_by) if filter_by
    things=things.where("people.last_name ILIKE ?",search+"%") if search
    things.order("#{klass.sort_by(sort_by)} #{reverse_sort ? "DESC" : "ASC"}")
  end
end
