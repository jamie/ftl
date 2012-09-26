require 'spec_helper'

describe Achievement do
  it "serializes" do
    a = Achievement.new
    a.id = 'ACH_SECTOR_5'
    a.difficulty = 'normal'
    a.to_binary_s.should == "\x0c\x00\x00\x00ACH_SECTOR_5\x01\x00\x00\x00"
  end
end
