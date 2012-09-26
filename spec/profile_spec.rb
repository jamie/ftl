require 'spec_helper'

describe Profile do
  let(:profile) {
    File.open('./spec/prof.sav') do |file|
      Profile.read(file)
    end
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

  it "loads ships" do
    profile.ships.should == [
      'kestrel',
      'stealth',
      'engi',
      'federation',
      'rock',
      'zoltan',
    ]
  end

  it "serializes full save file" do
    Profile.new(
      'version' => 4,
      'achievements' => [
        ['ACH_SECTOR_5', 'easy'],
        ['ACH_UNLOCK_ALL', 'normal'],
        ['ACH_FULL_ARSENAL', 'easy'],
        ['ACH_TOUGH_SHIP', 'easy']
      ]
    ).to_binary_s.should == File.read('./spec/prof.sav')
  end
end
