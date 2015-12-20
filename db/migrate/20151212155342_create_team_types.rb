class CreateTeamTypes < ActiveRecord::Migration
  def change
    create_table :team_types do |t|
      t.string :title

      t.timestamps
    end
  end
end
