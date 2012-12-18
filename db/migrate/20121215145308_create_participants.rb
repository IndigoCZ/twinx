class CreateParticipants < ActiveRecord::Migration
  def change
    create_table :participants do |t|
      t.integer :starting_no
      t.integer :team_id
      t.integer :category_id
      t.integer :person_id

      t.timestamps
    end
  end
end
