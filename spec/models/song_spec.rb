# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Song, type: :model do
  extend WithQueueAdapter
  with_queue_adapter :test

  it { should validate_presence_of :name }

  it 'should enqueue an IcecastUpdateJob after it is created' do
    song = build :song

    expect { song.save! }.to have_enqueued_job(IcecastUpdateJob)
  end
end
