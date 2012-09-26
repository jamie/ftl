require 'spec_helper'

describe ShipList do
  it 'serializes' do
    ship_list = ShipList.new
    ship_list.set(%w(kestrel engi crystal rock))
    
    expected = [1,0,0,1,0,0,1,0,1].pack("L<L<L<L<L<L<L<L<L<")
    ship_list.to_binary_s.should == expected
  end
end