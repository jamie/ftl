require 'rubygems'
require 'bundler/setup'

require 'bindata'
require 'pp'

class Nstring < BinData::Primitive
  uint32le :len, :value => lambda { data.length }
  string :data, :read_length => :len
  
  def get; self.data; end
  def set(v); self.data = v; end
end

class Difficulty < BinData::Primitive
  DIFFICULTIES = ['easy', 'normal']
  uint32le :data

  def get; DIFFICULTIES[self.data]; end
  def set(a); self.data = DIFFICULTIES.index(a); end
end
class Achievement < BinData::Primitive
  nstring :id
  difficulty :difficulty

  def get; [self.id, self.difficulty]; end
  def set(a); self.id = a[0]; self.difficulty = a[1]; end
end
class AchievementList < BinData::Primitive
  uint32le :len
  array :data, :type => :achievement, :initial_length => :len

  def get; self.data; end
  def set(a); self.data = a; end
end

class ShipList < BinData::Primitive
  FLAGS = %w(kestrel stealth mantis engi federation slug rock zoltan crystal)
  array :data, :type => :uint32le, :initial_length => 9

  def get
    [FLAGS, self.data].transpose.select{|ship, unlocked| unlocked == 1}.map(&:first)
  end
  def set(a)
    self.data = FLAGS.map{|ship| a.include?(ship) ? 1 : 0 }
  end
end

class Score < BinData::Record
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
  array :data, :type => :score, :initial_length => :len

  def get; self.data; end
  def set(a); self.data = a; end
end

class CrewScore < BinData::Record
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
  ship_list :ships
    
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
  
  crew_score :repairs
  crew_score :combat_kills
  crew_score :piloted_evasions
  crew_score :jumps_survived
  crew_score :skill_masteries
end
