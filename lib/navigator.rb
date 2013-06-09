class Navigator
  def initialize(navigation_params)
    @params=navigation_params.dup
  end
  def sort_by
    @params.fetch(:rsort) do
      @params.fetch(:sort) {"default"}
    end
  end
  def reverse_sort
    @params.has_key?(:rsort)
  end
end
