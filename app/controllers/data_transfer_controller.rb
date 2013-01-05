# encoding: UTF-8
require 'csv'
class DataTransferController < ApplicationController
  def index
  end
  def create
    arr_of_arrs = CSV.parse(params[:import].read)
    header_list=arr_of_arrs.shift
    array_of_hashes=[]
    arr_of_arrs.each do |line|
      row={}
      header_list.each_with_index do |head,i|
        row[head]=line[i]
      end
      array_of_hashes<<row
    end
    array_of_hashes.each do |row|
      county=County.where(title:row["team"]).first_or_create
      person=Person.lookup_or_create(
       "first_name" => row["first_name"],
       "last_name" => row["last_name"],
       "full_name" => row["full_name"],
       "gender" => row["gender"],
       "yob" => row["yob"],
       "born" => row["born"],
       "id_string" => row["id_string"],
       "county_id" => county.id
      )
      if row["competing"]=="true"
        if @current_race.categories.where(code:row["category"]).size == 1
          category=@current_race.categories.where(code:row["category"]).first
        else
          category=Category.create_by_code(@current_race,row["category"])
        end
        team=Team.where(race_id:@current_race.id,county_id:county.id).first_or_create
        if @current_race.participants.where(starting_no:row["starting_no"]).size == 1
          participant=@current_race.participants.where(starting_no:row["starting_no"]).first
        else
          participant=Participant.create(starting_no:row["starting_no"],person_id:person.id,team_id:team.id,category_id:category.id)
        end
        if row["position"] && row["position"].to_i > 0
          if participant.result
            logger.info "Participant #{participant.starting_no} already has a result"
          else
            if row["time"]
              Result.create(participant_id:participant.id,position:row["position"],time:row["time"])
            else
              Result.create(participant_id:participant.id,position:row["position"])
            end
          end
        end
      end
    end
    redirect_to race_data_transfer_index_path(@current_race), notice: 'Import'
  end
end
