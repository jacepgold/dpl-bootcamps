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

require 'rails_helper'

RSpec.describe Bootcamp, type: :model do
  describe 'attributes' do
    it { should respond_to(:name) }
    it { should respond_to(:year_founded) }
    it { should respond_to(:active) }
    it { should respond_to(:languages) }
    it { should respond_to(:full_time_tuition_cost) }
    it { should respond_to(:part_time_tuition_cost) }
  end

  describe 'validations' do
    context 'presence of validations' do
      it { should validate_presence_of(:name) }
      it { should validate_presence_of(:year_founded) }
      it { should validate_presence_of(:full_time_tuition_cost) }
      it { should validate_presence_of(:part_time_tuition_cost) }
    end

    context 'uniqueness validations' do
      it { should validate_uniqueness_of(:name) }
    end

    context 'inclusion of validations' do
      it do
        should validate_inclusion_of(:year_founded).
          in_array( (2000..Date.today.year).to_a )
      end
    end
  end

  describe 'class methods / scopes' do
    before(:each) do
      @bootcamp_1 = FactoryBot.create(
        :bootcamp, 
        name: 'NY Code Academy', 
        full_time_tuition_cost: 11000,
        part_time_tuition_cost: 7000
      )
      @bootcamp_2 = FactoryBot.create(:bootcamp, name: 'Iron Yard')
      @bootcamp_3 = FactoryBot.create(
        :bootcamp,
        name: 'DevPoint Labs', 
        full_time_tuition_cost: 20000,
        part_time_tuition_cost: 3000
      )
    end

    it 'returns bootcamps ordered by name' do
      bootcamps = Bootcamp.all.by_name
      expect(bootcamps.first).to eq(@bootcamp_3)
      expect(bootcamps[1]).to eq(@bootcamp_2)
      expect(bootcamps.last).to eq(@bootcamp_1)
    end

    it 'returns bootcamps ordered by full time tuition cost desc' do
      bootcamps = Bootcamp.all.by_full_time_tuition_cost
      expect(bootcamps.first).to eq(@bootcamp_3)
      expect(bootcamps[1]).to eq(@bootcamp_1)
      expect(bootcamps.last).to eq(@bootcamp_2)
    end

    it 'returns bootcamps ordered by part time tuition cost desc' do
      bootcamps = Bootcamp.all.by_part_time_tuition_cost
      expect(bootcamps.first).to eq(@bootcamp_1)
      expect(bootcamps[1]).to eq(@bootcamp_2)
      expect(bootcamps.last).to eq(@bootcamp_3)
    end
  end
end
