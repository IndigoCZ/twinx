class AddTitleToTeam < ActiveRecord::Migration
  def up
    add_column :teams, :title, :string
    County.find(:all).each do |county|
      Team.where(county_id:county.id).each do |team|
        team.title=county.title
        team.save
      end
    end
  end
  def down
    remove_columt :teams, :title
  end
end
