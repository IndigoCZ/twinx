namespace :twinx do
  desc "Compute TOP 3 group race results"
  task :top_threes => :environment do
    race=Race.find(15)
    main_category=Category.first_or_create_by_code(race,"M")
    threes_positions=Hash.new
    main_category.participants.each do |participant|
      if participant.result
        t_team=participant.team.county.title
        if threes_positions.has_key?(t_team) then
          threes_positions[t_team]<< participant.result.position
        else
          threes_positions[t_team]=[participant.result.position]
        end
        puts participant.team.county.title
        puts threes_positions
      end
    end
    threes_scores=Hash.new
    threes_positions.each_pair do |t_team,positions|
      tmp_pos=positions.sort.first(3)
      score=tmp_pos.sum           # Summed positions
      score+=(3-tmp_pos.size)*100 # Penalty
      score=score.to_f+(tmp_pos.first.to_f/100)
      threes_scores[t_team]=score
    end
    puts "Obec,Hodnocení"
    threes_scores.sort_by{|_key,score| score}.each do |tuple|
      puts "#{tuple[0]},#{tuple[1].to_i}"
    end
    puts main_category.participants.count
  end
end
