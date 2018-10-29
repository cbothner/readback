# frozen_string_literal: true

class EpisodeDecorator
  # Format an episode information based on what kind of activity it is
  module ActivityFormatter
    # A weekly show
    class Base
      include Draper::ViewHelpers

      def initialize(episode)
        @episode = episode
      end

      # Played 20 songs on Ceci n’est pas Freeform
      def to_s
        "#{played_songs.capitalize} #{on_show}"
      end

      def icon_classes
        %w[fas fa-calendar-check]
      end

      private

      def played_songs
        <<~HTML
          played #{h.link_to h.pluralize(@episode.songs.length, 'song'),
                             h.episode_songs_path(@episode)}
        HTML
      end

      def on_show
        <<~HTML
          on
          #{h.link_to @episode.show.unambiguous_name, h.url_for(@episode.show)}
        HTML
      end
    end

    # A specialty show the DJ rotates on
    class Rotating < Base
      # Rotated on Radiozilla and played 10 songs
      def to_s
        "Rotated #{on_show} and #{played_songs}"
      end

      def icon_classes
        %w[fas fa-sync-alt]
      end
    end

    # An episode the DJ covered for someone else
    class Sub < Base
      # Subbed on Selective Memory and played 20 songs
      def to_s
        "Subbed #{on_show} and #{played_songs}"
      end

      def icon_classes
        %w[fas fa-hand-peace]
      end
    end

    def self.for(episode)
      klass_for(episode).new episode
    end

    def self.klass_for(episode)
      return Rotating if episode.dj.all_specialty_shows.include? episode.show
      return Sub if episode.sub_requests.exists?
      Base
    end
  end
end
