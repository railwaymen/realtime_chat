# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Room, type: :model do
  it 'validates name' do
    expect(build(:room, name: :_name, type: :open)).to_not be_valid
    expect(build(:room, name: :name, type: :open)).to be_valid
    expect(build(:room, name: :_name, type: :direct)).to be_valid
  end
end
