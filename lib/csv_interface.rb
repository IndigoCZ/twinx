class CSVInterface
  def self.header
    %w[starting_no first_name last_name full_name gender yob team category position time born competing id_string]
  end

  def self.export(race)
    CSV.generate do |csv|
      csv << self.header
      Participant.for_race(race).each do |participant|
        row=[]
        header.each do |col|
          row<<participant.attr_for_csv(col)
        end
        csv << row
      end
    end
  end

  def self.attr_for_csv(column)
    case column
    when "starting_no"
      starting_no
    when "first_name"
      person.first_name
    when "last_name"
      person.last_name
    when "full_name"
      person.full_name
    when "gender"
      person.gender
    when "yob"
      person.yob
    when "team"
      team.title
    when "category"
      category.code
    when "position"
      if result
        result.position
      else
        "DNF"
      end
    when "time"
      if result && result.time
        result.time
      else
        nil
      end
    when "born"
      person.born
    when "competing"
      true
    when "id_string"
      person.id_string
    end
  end

  def import(csv_data)
    arr_of_arrs = CSV.parse(csv_data)
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
  end

end
