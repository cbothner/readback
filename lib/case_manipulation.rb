# Ruby Linguistics is from ged/linguistics

# Exceptions: Indefinite articles
ARTICLES = %w[a and the]

# Exceptions: Prepositions shorter than five letters
SHORT_PREPOSITIONS = ["amid", "at", "but", "by", "down", "for", "from", "in",
  "into", "like", "near", "of", "off", "on", "onto", "out", "over",
  "past", "save", "with", "till", "to", "unto", "up", "upon", "with"]

# Exceptions: Coordinating conjunctions
COORD_CONJUNCTIONS = %w[and but as]

RECORD_LABELS = %w[EMI WB]

# Titlecase exceptions: "In titles, capitalize the first word, the
# last word, and all words in between except articles (a, an, and
# the), prepositions under five letters (in, of, to), and coordinating
# conjunctions (and, but). These rules apply to titles of long, short,
# and partial works as well as your own papers" (Anson, Schwegler,
# and Muth. The Longman Writer's Companion 240).
TITLE_CASE_EXCEPTIONS = ARTICLES | SHORT_PREPOSITIONS | COORD_CONJUNCTIONS | RECORD_LABELS

class String
  def case
    return :upcase if !self[/[[:lower:]]/]
    return :downcase if !self[/[[:upper:]]/]
    return :hedcase
  end

  # File lib/linguistics/en/titlecase.rb, line 68
  def hedcase

    # Split on word-boundaries
    words = self.to_s.split( /\b/ )

    # Always capitalize the first and last words
    words.first.gsub!( /^(\w)(.*)/ ) { $1.upcase + $2 }
    words.last.gsub!( /^(\w)(.*)/ ) { $1.upcase + $2 }

    # Now scan the rest of the tokens, skipping non-words and capitalization
    # exceptions.
    words.each_with_index do |word, i|

      # Non-words
      next unless /^\w+$/.match( word )

      # Skip exception-words
      next if TITLE_CASE_EXCEPTIONS.include?( word )

      # Skip second parts of contractions
      next if words[i - 1] == "'" && /\w/.match( words[i - 2] )

      # Have to do it this way instead of capitalize! because that method
      # also downcases all other letters.
      word.gsub!( /^(\w)(.*)/ ) { $1.upcase + $2 }
    end

    return words.join
  end
end
