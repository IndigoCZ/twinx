class MimoSoutez < ActiveRecord::Migration
  def up
    TeamType.find_or_create_by(title:"Mimo Soutěž")
  end

  def down
    mimo_soutez=TeamType.find_by(title:"Mimo Soutěž")
    if mimo_soutez && mimo_soutez.teams.reload.empty?
      mimo_soutez.delete
    end
  end
end
