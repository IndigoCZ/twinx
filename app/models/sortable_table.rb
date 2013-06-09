# encoding: UTF-8
module SortableTable
  def filter_by(string)
    column,val=string.split("_")
    self.send("by_#{column}_id",val)
  end

  def sort_by(column=nil)
    self.sort_attrs.fetch(column) { sort_attrs["default"] }
  end
end
