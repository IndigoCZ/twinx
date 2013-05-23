require 'ostruct'
class CSVConsumer < OpenStruct
  def save
    get_category
    get_county
    get_team
    get_person
    get_participant
    get_result unless position.empty?
  end
  def get_category
    @category_id||=Category.first_or_create_by_code(race,category)
  end
  def get_county
    @county_id||=County.first_or_create(title:team).id
  end
  def get_team
    @team_id||=Team.first_or_create_for_race_and_county(race,get_county).id
  end
  def get_person
    return @person_id if @person_id
    person=Person.new(
        first_name:first_name,
        last_name:last_name,
        gender:gender,
        yob:yob,
        county_id:get_county
      )
    person.full_name=full_name if full_name
    person.born=born if born
    person.id_string=id_string if id_string
    person.save
    @person_id=person.id
  end
  def get_participant
    @participant_id||=Participant.create(starting_no:starting_no,person_id:get_person,team_id:get_team,category_id:get_category)
  end
  def get_position
    return nil if position.nil? || position.empty?
    position
  end
  def get_time
    return nil if time.nil? || time.empty?
    time
  end
  def get_result
    @result_id||=Result.create(participant_id:get_participant,position:get_position,time:get_time)
  end
=begin
    return "Nothing loaded" unless check_header(header,["category"])
    body.each do |row|
    end
    return "Categories loaded" unless check_header(header,["team"])
    body.each do |row|
    end
    return "Teams loaded" unless check_header(header,["first_name","last_name","yob","gender","team"])
    person_attributes=Person.attribute_names
    body.each do |row|
      person=Person.new
      person_attributes.each do |attr|
        person.send("#{attr}=",row[attr]) if row.has_key? attr
      end
      person.county=row["team"]
      person.save
      person.dedup
    end
=end
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
        category=Category.first_or_create_by_code(@current_race,row["category"])
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
