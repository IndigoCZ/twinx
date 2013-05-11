require 'duration'
describe Duration do
  context "special cases" do
    it "can handle nil properly" do
      dur=Duration.new(nil)
      dur.to_i.should eq nil
      dur.to_s.should eq nil
    end
    it "can handle 0 properly" do
      dur=Duration.new(0)
      dur.to_i.should eq nil
      dur.to_s.should eq nil
    end
  end
  context "parsing" do
    it "can be initialized from number of ms" do
      Duration.from_ms(999).to_i.should eq 999
    end
    it "can be initialized from string" do
      Duration.from_string("1:23.45").to_i.should eq 83450
      Duration.from_string("0:1.12").to_i.should eq 1120
    end
    it "can be initialized from hash" do
      Duration.from_hash({"fract"=>1,"sec"=>2,"min"=>3}).to_i.should eq 182100
      Duration.from_hash({"fract"=>"12","sec"=>"1","min"=>"0"}).to_i.should eq 1120
    end
  end
  context "formatting" do
    it "can return the duration in number of milliseconds" do
      Duration.new(777).to_i.should eq 777
    end
    it "can return the duration as a string" do
      Duration.new(60000).to_s.should eq "1:00.000"
      Duration.new(123456).to_s.should eq "2:03.456"
      Duration.new(59999).to_s.should eq "0:59.999"
      Duration.new(1).to_s.should eq "0:00.001"
    end
  end
end

