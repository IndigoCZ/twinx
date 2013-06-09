require 'navigator'
describe Navigator do
  it "reports default sort order when no sort order given" do
    navigator=Navigator.new({})
    navigator.sort_by.should == "default"
    navigator.reverse_sort.should be_false
  end
  it "reports chosen sort order when sort order given" do
    navigator=Navigator.new({sort:"other"})
    navigator.sort_by.should == "other"
    navigator.reverse_sort.should be_false
  end
  it "reports chosen reverse sort order when given one" do
    navigator=Navigator.new({rsort:"someorder"})
    navigator.sort_by.should == "someorder"
    navigator.reverse_sort.should be_true
  end
end
