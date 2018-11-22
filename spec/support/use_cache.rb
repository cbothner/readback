# frozen_string_literal: true

module UseCache
  def use_cache
    memory_store = ActiveSupport::Cache.lookup_store(:memory_store)
    allow(Rails).to receive(:cache).and_return memory_store
    Rails.cache.clear
  end
end
