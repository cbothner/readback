# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Semester, type: :model do
  Semester.create(beginning: 2.weeks.ago, ending: 2.weeks.since)

  subject { described_class.new }

  it 'conflicts with existing semester' do
    subject.beginning = 1.week.ago
    subject.ending = 3.weeks.since
    expect(subject).not_to be_valid
  end

  it 'begins on the end date of existing semester' do
    subject.beginning = 2.weeks.since
    subject.ending = 6.weeks.since
    expect(subject).to be_valid
  end

  it 'does not conflict with existing semester' do
    subject.beginning = 3.weeks.since
    subject.ending = 7.weeks.since
    expect(subject).to be_valid
  end
end
