require 'spec_helper'

describe Profile do
  let(:profile) {
    file = File.open('./spec/prof.sav')
    Profile.read(file)
  }
  
  it "loads" do
    profile['version'].should == 4
  end
end
