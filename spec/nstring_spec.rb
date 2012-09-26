require 'spec_helper'

describe Nstring do
  it "encodes a string with length prepended" do
    Nstring.new("Hello").to_binary_s.should == "\x05\x00\x00\x00Hello"
  end
end
