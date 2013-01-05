class AddDetailsToCategory < ActiveRecord::Migration
  def change
		add_column :categories, :code, :string
		add_column :categories, :sort_order, :integer
  end
end
