class StatsController < ApplicationController
  def index
    @participant_count=@current_race.participants.count
    current_race_participants=@current_race.participants.includes(:person)
    males=current_race_participants.where("people.gender='male'")
    females=current_race_participants.where("people.gender='female'")
    @top_participants={}
    @top_participants[[:young,:male]]=males.order("people.yob DESC").order("people.born DESC NULLS LAST").first
    @top_participants[[:old,:male]]=males.order("people.yob").order("people.born NULLS LAST").first
    @top_participants[[:young,:female]]=females.order("people.yob DESC").order("people.born DESC NULLS LAST").first
    @top_participants[[:old,:female]]=females.order("people.yob").order("people.born NULLS LAST").first
    respond_to do |format|
      format.html
      format.pdf
    end
  end
end
