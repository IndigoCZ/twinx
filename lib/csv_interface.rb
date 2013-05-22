require 'csv'
require 'csv_presenter'
module CSVInterface
  class InvalidField < Exception; end
  class MissingField < Exception; end
  extend self

  # External Interface

  def export(participants,header)
    check_header(header)
    CSV.generate do |csv|
      csv << header
      participants.each do |participant|
        row=[]
        participant=CSVPresenter.new(participant)
        header.each do |col|
          row<<participant.send(col)
        end
        csv<<row
      end
    end
  end

  def import(race,csv_data)
    csv_data = CSV.parse(csv_data)
    header=csv_data.shift
    check_header(header)
    body=parse_body(csv_data,header)
    body
  end

  # Internals

  def valid_fields
    %w[starting_no first_name last_name full_name gender yob team category position time born id_string]
  end

  def valid_field?(field_name)
    valid_fields.include?(field_name)
  end

  def check_header(header,required=[])
    header.each do |col|
      raise InvalidField.new("#{col} is not valid") unless valid_field?(col)
    end
    required.each do |col|
      raise MissingField unless header.include?(col)
    end
  end
  def parse_body(csv_body,header)
    hash_per_line=[]
    csv_body.each do |line|
      row={}
      header.each_with_index do |head,i|
        row[head]=line[i]
      end
      hash_per_line<<row
    end
    hash_per_line
  end
=begin
    array_of_hashes.each do |row|
      logger.info("Importing #{row["starting_no"]}")
      county=County.where(title:row["team"]).first_or_create
      person=Person.create(
        first_name:row["first_name"],
        last_name:row["last_name"],
        full_name:row["full_name"],
        gender:row["gender"],
        yob:row["yob"],
        born:row["born"],
        id_string:row["id_string"],
        county_id:county.id
      )
      person.dedup
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
            result=participant.result
            result.position=row["position"]
            if row["time"]
              result.time=row["time"]
            end
            result.save
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
=end
end
