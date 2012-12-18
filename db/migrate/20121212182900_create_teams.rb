class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer :county_id
      t.integer :race_id

      t.timestamps
    end
  end
end
