require 'navigator'
describe Navigator do
  it "reports default sort order when no sort order given" do
    navigator=Navigator.new({})
    expect(navigator.sort_by).to eq("default")
    expect(navigator.reverse_sort).to be_falsey
  end
  it "reports chosen sort order when sort order given" do
    navigator=Navigator.new({sort:"other"})
    expect(navigator.sort_by).to eq("other")
    expect(navigator.reverse_sort).to be_falsey
  end
  it "reports chosen reverse sort order when given one" do
    navigator=Navigator.new({rsort:"someorder"})
    expect(navigator.sort_by).to eq("someorder")
    expect(navigator.reverse_sort).to be_truthy
  end
end
