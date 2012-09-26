require 'rubygems'
require 'bundler/setup'

require 'bindata'
require 'pp'

class Str < BinData::Primitive
  endian :little
  uint32 :len, :value => lambda { :data.length }
  string :data, :read_length => :len
  
  def get; self.data; end
  def set(v); self.data = v; end
end

class Ary < BinData::Primitive
  endian :little
  uint32 :len, :value => lambda { :data.length }
  array :data, :type => :type_t, :initial_length => :len

  def get; self.data; end
  def set(v); self.data = v; end
end

class CrewRecord < BinData::Record
  endian :little
  
  uint32 :score
  str :name
  str :race
  uint32 :gender_
end

class Flag < BinData::Choice
  uint32le 0
  uint32le 1
end

class HighScore < BinData::Record
  endian :little

  str :name
  str :photo_id
  uint32 :score
  uint32 :sector
  uint32 :win
  uint32 :difficulty_  
end

class Profile < BinData::Record
  endian :little
  
  uint32 :version_
  
  uint32 :achievement_count
  array :achievements, :initial_length => :achievement_count do
    str :id
    uint32 :_ # four null bytes - difficulty?
  end
  
  flag :kestrel_cruiser
  flag :stealth_cruiser
  flag :mantis_cruiser
  flag :engi_cruiser
  flag :federation_cruiser
  flag :slug_cruiser
  flag :rock_cruiser
  flag :zoltan_cruiser
  flag :crystal_cruiser
  
  struct :flags do
    uint32 :_1
    uint32 :_2
    uint32 :_3
  end
  
  uint32 :highscore_count
  array :highscores, :type => :high_score, :initial_length => :highscore_count

  uint32 :ship_highscore_count
  array :ship_highscores, :type => :high_score, :initial_length => :ship_highscore_count  
  
  uint32 :ships_defeated
  uint32 :total_ships_defeated
  uint32 :beacons_explored
  uint32 :total_beacons_explored
  uint32 :scrap_collected
  uint32 :total_scrap_collected
  uint32 :crew_hired
  uint32 :total_crew_hired
  
  uint32 :games_played
  uint32 :victories
  
  crew_record :repairs
  crew_record :combat_kills
  crew_record :piloted_evasions
  crew_record :jumps_survived
  crew_record :skill_masteries
end

file = File.open(ARGV.first)
pp Profile.read(file)
