Rails.application.configure do
  config.action_view.sanitized_allowed_tags =
    ActionView::Base.sanitized_allowed_tags + %w[figure figcaption]
end
