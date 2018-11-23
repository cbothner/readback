# frozen_string_literal: true

# Null Object for DJ (for authorization logic)
class Listener
  include Singleton

  def has_role?(*_args)
    false
  end
  alias has_cached_role? has_role?
end
