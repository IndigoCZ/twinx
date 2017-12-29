class Race < ActiveRecord::Base
  extend ModelDependencyHandling

  attr_accessor :ruleset
  validates_presence_of :title, :held_on
  has_many :categories
  has_many :teams
  has_many :participants, :through => :categories
  has_many :results, :through => :participants
  block_deletion_on_dependency :categories, :teams
end
