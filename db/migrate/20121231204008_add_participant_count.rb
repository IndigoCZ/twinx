class AddParticipantCount < ActiveRecord::Migration
  def up
    add_column :teams, :participants_count, :integer, :default => 0
    add_column :categories, :participants_count, :integer, :default => 0
    Category.reset_column_information
    Category.find(:all).each do |c|
      Category.update_counters c.id, :participants_count => c.participants.length
    end
    Team.reset_column_information
    Team.find(:all).each do |t|
      Team.update_counters t.id, :participants_count => t.participants.length
    end
  end

  def down
    remove_column :teams, :participants_count
    remove_column :categories, :participants_count
  end
end
