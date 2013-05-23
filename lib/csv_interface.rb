require 'csv'
require 'csv_presenter'
require 'csv_consumer'
module CSVInterface
  class InvalidField < Exception; end
  class MissingField < Exception; end
  extend self

  # External Interface

  def export(participants,header)
    raise InvalidField.new("One of the header fields is invalid") unless check_header(header)
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
    consumers=parse_body(csv_data,header,race)
    consumers.each do |consumer|
      consumer.save
    end
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
      return false unless valid_field?(col)
    end
    required.each do |col|
      return false unless header.include?(col)
    end
    return true
  end
  def parse_body(csv_body,header,race)
    csv_body.map do |line|
      row={}
      header.each_with_index do |head,i|
        row[head]=line[i]
      end
      row["race"]=race
      CSVConsumer.new(row)
    end
  end
end
