require 'spec_helper'

describe DifficultyObserver do
  it "should update the difficulty cache field on category" do
    @cat = mock_model(Category, difficulty:50)
    @con = FactoryGirl.build(:constraint, category:@cat)
    @obs = DifficultyObserver.instance
    @cat.should_receive(:update_attribute).with(:difficulty, 50)
    @obs.after_save(@con)
    @cat.should_receive(:difficulty=).with(50)
    @obs.before_validation(@cat)
  end
end
