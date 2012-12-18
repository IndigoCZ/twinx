class CreateCategoryConstraints < ActiveRecord::Migration
  def change
    create_table :category_constraints do |t|
      t.integer :category_id
      t.string :type
      t.string :value

      t.timestamps
    end
  end
end
