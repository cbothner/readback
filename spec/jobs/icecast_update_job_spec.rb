# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IcecastUpdateJob, type: :job do
  it 'should hit the icecast endpoint and update the stream metadata' do
    #
    # Given
    allow(ENV).to receive(:[]).with('ICECAST_ADMIN_PASSWORD')
                              .and_return 'password'

    show = object_double 'FreeformShow', name: 'Freeform'
    episode = object_double 'Episode', dj: 'Cameron', show: show
    song = object_double 'Song', artist: 'The Decemberists',
                                 name: 'Sons and Daughters',
                                 episode: episode

    job = IcecastUpdateJob.new
    allow(job).to receive :system

    #
    # Act
    job.perform(song)

    #
    # Assert
    expect(job).to have_received(:system).with(
      'curl', '--max-time', /[\d.]+/, '--user', 'admin:password',
      'http://floyd.wcbn.org:8000/admin/metadata?mount=/wcbn-hd.mp3&' \
      'song=WCBN-FM%3A+%E2%80%9CSons+and+Daughters%E2%80%9D+by' \
      '+The+Decemberists+%E2%80%93+on+Freeform+with+Cameron&mode=updinfo'
    )

    expect(job).to have_received(:system).with(
      'curl', '--max-time', /[\d.]+/, '--user', 'admin:password',
      'http://floyd.wcbn.org:8000/admin/metadata?mount=/wcbn-mid.mp3&' \
      'song=WCBN-FM%3A+%E2%80%9CSons+and+Daughters%E2%80%9D+by' \
      '+The+Decemberists+%E2%80%93+on+Freeform+with+Cameron&mode=updinfo'
    )

    expect(job).to have_received(:system).with(
      'curl', '--max-time', /[\d.]+/, '--user', 'admin:password',
      'http://floyd.wcbn.org:8000/admin/metadata?mount=/wcbn-hi.mp3&' \
      'song=WCBN-FM%3A+%E2%80%9CSons+and+Daughters%E2%80%9D+by' \
      '+The+Decemberists+%E2%80%93+on+Freeform+with+Cameron&mode=updinfo'
    )
  end

  context 'when the song artist is not set' do
    it 'should not add the preposition “by” to the stream metadata' do
      #
      # Given
      allow(ENV).to receive(:[]).with('ICECAST_ADMIN_PASSWORD')
                                .and_return('password')

      show = object_double('FreeformShow', name: 'Freeform')
      episode = object_double('Episode', dj: 'Cameron', show: show)
      song = object_double('Song', artist: '', name: 'Sons and Daughters',
                                   episode: episode)

      job = IcecastUpdateJob.new
      allow(job).to receive :system

      #
      # Act
      job.perform(song)

      #
      # Assert
      expect(job).to have_received(:system).with(
        'curl', '--max-time', /[\d.]+/, '--user', 'admin:password',
        'http://floyd.wcbn.org:8000/admin/metadata?mount=/wcbn-hd.mp3&' \
        'song=WCBN-FM%3A+%E2%80%9CSons+and+Daughters%E2%80%9D+' \
        '%E2%80%93+on+Freeform+with+Cameron&mode=updinfo'
      )

      expect(job).to have_received(:system).with(
        'curl', '--max-time', /[\d.]+/, '--user', 'admin:password',
        'http://floyd.wcbn.org:8000/admin/metadata?mount=/wcbn-mid.mp3&' \
        'song=WCBN-FM%3A+%E2%80%9CSons+and+Daughters%E2%80%9D+' \
        '%E2%80%93+on+Freeform+with+Cameron&mode=updinfo'
      )

      expect(job).to have_received(:system).with(
        'curl', '--max-time', /[\d.]+/, '--user', 'admin:password',
        'http://floyd.wcbn.org:8000/admin/metadata?mount=/wcbn-hi.mp3&' \
        'song=WCBN-FM%3A+%E2%80%9CSons+and+Daughters%E2%80%9D+' \
        '%E2%80%93+on+Freeform+with+Cameron&mode=updinfo'
      )
    end
  end
end
