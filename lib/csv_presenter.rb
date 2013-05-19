require 'null_result'
class CSVPresenter
  def initialize(participant)
    @participant=participant
    @person=participant.person
    @result=participant.result || NullResult.new
    @team=participant.team
    @category=participant.category
  end
  def starting_no
    @participant.starting_no
  end
  def first_name
    @person.first_name
  end
  def last_name
    @person.last_name
  end
  def full_name
    @person.full_name
  end
  def gender
    @person.gender
  end
  def yob
    @person.yob
  end
  def team
    @team.title
  end
  def category
    @category.code
  end
  def position
    @result.position
  end
  def time
    @result.time
  end
  def born
    @person.born
  end
  def id_string
    @person.id_string
  end
end
