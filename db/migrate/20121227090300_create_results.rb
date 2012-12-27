class CreateResults < ActiveRecord::Migration
  def change
    create_table :results do |t|
      t.integer :position
      t.integer :time_msec
      t.references :participant

      t.timestamps
    end
    add_index :results, :participant_id
  end
end
