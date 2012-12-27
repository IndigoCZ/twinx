class CreateConstraints < ActiveRecord::Migration
  def change
    create_table :constraints do |t|
      t.integer :category_id
      t.string  :restrict
      t.string  :string_value
      t.integer :integer_value

      t.timestamps
    end
  end
end
