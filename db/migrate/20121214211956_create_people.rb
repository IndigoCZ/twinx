class CreatePeople < ActiveRecord::Migration
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :full_name
      t.string :gender
      t.integer :yob
      t.date :born
      t.integer :county_id
      t.string :id_string

      t.timestamps
    end
  end
end
