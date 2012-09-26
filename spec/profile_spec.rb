require 'spec_helper'

describe Profile do
  let(:profile) {
    file = File.expand_path(YAML.load(File.read('config.yml'))['mac']) + '/prof.sav'
    file = File.open(file)
    Profile.read(file)
  }
  
  it "loads" do
    profile['version'].should == 4
  end
end
