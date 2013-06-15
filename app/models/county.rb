class County < ActiveRecord::Base
  extend ModelDependencyHandling
  #attr_accessible :title
  validates_presence_of :title
  validates_uniqueness_of :title
  has_many :teams
  has_many :people
  block_deletion_on_dependency :people, :teams

  scope :finder, lambda { |q| where("title like :q", q: "%#{q}%") }
end
