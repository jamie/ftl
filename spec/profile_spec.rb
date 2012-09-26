require 'spec_helper'

describe Profile do
  let(:profile) {
    file = File.open('./spec/prof.sav')
    Profile.read(file)
  }
  
  it "loads version" do
    profile.version.should == 4
  end

  it "loads achievements" do
    profile.achievements.should == [
      ['ACH_SECTOR_5', 'easy'],
      ['ACH_UNLOCK_ALL', 'normal'],
      ['ACH_FULL_ARSENAL', 'easy'],
      ['ACH_TOUGH_SHIP', 'easy']
    ]
  end

  it "builds with a hash" do
    p = Profile.new(
      :version => 4,
      :achievements => [['ACH_SECTOR_5', 'easy']]
    )
    p.version.should == 4
    p.achievements.should == [['ACH_SECTOR_5', 'easy']]
  end
end
