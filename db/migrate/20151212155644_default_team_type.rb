class DefaultTeamType < ActiveRecord::Migration
  def up
		add_column :teams, :team_type_id, :integer
    default_team_type=TeamType.create(title:"Orel")
    TeamType.create(title:"Sokol")
    TeamType.create(title:"Obec")
    TeamType.create(title:"SK")
    TeamType.create(title:"FC")
    Team.all.each do |team|
      team.team_type=default_team_type
      team.title="#{team.team_type.title} #{team.county.title}"
      team.save
    end
  end

  def down
    Team.all.each do |team|
      team.title=team.county.title
      team.save
    end
    TeamType.delete_all
		remove_column :teams, :team_type_id
  end
end
