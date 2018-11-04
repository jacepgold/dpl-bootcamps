# == Schema Information
#
# Table name: bootcamps
#
#  id                     :integer          not null, primary key
#  name                   :string           default(""), not null
#  year_founded           :integer          default(2018), not null
#  active                 :boolean          default(TRUE)
#  languages              :jsonb
#  full_time_tuition_cost :float            default(0.0), not null
#  part_time_tuition_cost :float            default(0.0), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class Bootcamp < ApplicationRecord
  validates_presence_of :name, :year_founded, :full_time_tuition_cost, :part_time_tuition_cost
  validates_uniqueness_of :name
  validates_inclusion_of :year_founded, in: (2000..Date.today.year).to_a

  # Class Methods - Scopes
  def self.by_name
    self.order(:name)
  end

  def self.by_full_time_tuition_cost
    self.order(full_time_tuition_cost: :desc)
  end

  def self.by_part_time_tuition_cost
    self.order(part_time_tuition_cost: :desc)
  end
end
