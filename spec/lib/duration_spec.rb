require 'duration'
describe Duration do
  context "special cases" do
    it "can handle nil properly" do
      dur=Duration.new(nil)
      expect(dur.to_i).to eq 0
      expect(dur.to_s).to eq ""
    end
    it "can handle 0 properly" do
      dur=Duration.new(0)
      expect(dur.to_i).to eq 0
      expect(dur.to_s).to eq ""
    end
  end
  context "parsing" do
    it "can be initialized from number of ms" do
      expect(Duration.from_ms(999).to_i).to eq 999
    end
    it "can be initialized from string" do
      expect(Duration.from_string("1:23.45").to_i).to eq 83450
      expect(Duration.from_string("0:1.12").to_i).to eq 1120
    end
    it "can be initialized from hash" do
      expect(Duration.from_hash({"fract"=>1,"sec"=>2,"min"=>3}).to_i).to eq 182100
      expect(Duration.from_hash({"fract"=>"12","sec"=>"1","min"=>"0"}).to_i).to eq 1120
    end
  end
  context "formatting" do
    it "can return the duration in number of milliseconds" do
      expect(Duration.new(777).to_i).to eq 777
    end
    it "can return the duration as a string" do
      expect(Duration.new(60000).to_s).to eq "1:00.000"
      expect(Duration.new(123456).to_s).to eq "2:03.456"
      expect(Duration.new(59999).to_s).to eq "0:59.999"
      expect(Duration.new(1).to_s).to eq "0:00.001"
    end
  end
end

