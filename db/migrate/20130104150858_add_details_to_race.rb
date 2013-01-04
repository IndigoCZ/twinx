class AddDetailsToRace < ActiveRecord::Migration
  def change
		add_column :races, :subtitle, :string
		add_column :races, :short_name, :string
  end
end
