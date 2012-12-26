class CreateConstraints < ActiveRecord::Migration
  def change
    create_table :constraints do |t|
      t.integer :category_id
      t.string :restrict
      t.string :value

      t.timestamps
    end
  end
end
