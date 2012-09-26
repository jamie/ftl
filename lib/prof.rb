require 'rubygems'
require 'bundler/setup'

require 'bindata'
require 'pp'

class Nstring < BinData::Primitive
  endian :little
  uint32 :len, :value => lambda { data.length }
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
  nstring :name
  nstring :race
  uint32 :gender_
end

class Gender < BinData::Record
  uint32le :e, :check_value => lambda { value == 0 or value == 1 }
  choice :int, :selection => :e,
               :choices => {0 => :int16be, 1 => :int16le}
end

class HighScore < BinData::Record
  endian :little

  nstring :name
  nstring :photo_id
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
    nstring :id
    uint32 :_ # four null bytes - difficulty?
  end
  
  uint32 :kestrel_cruiser
  uint32 :stealth_cruiser
  uint32 :mantis_cruiser
  uint32 :engi_cruiser
  uint32 :federation_cruiser
  uint32 :slug_cruiser
  uint32 :rock_cruiser
  uint32 :zoltan_cruiser
  uint32 :crystal_cruiser
  
  struct :unknown do
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

if $0 == __FILE__
  require 'yaml'
  default_file = File.expand_path(YAML.load(File.read('config.yml'))['test_path']) + '/prof.sav'
  file = File.open(ARGV.first || default_file)
  pp Profile.read(file)
end