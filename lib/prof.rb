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

class AchievementList < BinData::Primitive
  uint32le :len
  array :data, :initial_length => :len do
    nstring :id
    uint32le :_ # four null bytes - difficulty?
  end

  def get; self.data; end
  def set(a); self.data = a; end
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
class ScoreList < BinData::Primitive
  uint32le :len
  array :data, :type => :high_score, :initial_length => :len

  def get; self.data; end
  def set(a); self.data = a; end
end

class CrewRecord < BinData::Record
  endian :little
  
  uint32 :score
  nstring :name
  nstring :race
  uint32 :gender_
end

class Profile < BinData::Record
  endian :little
  
  uint32 :version
  
  achievement_list :achievements
  
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
  
  score_list :highscores
  score_list :ship_highscores
  
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