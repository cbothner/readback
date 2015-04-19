module ApplicationHelper
  def title(title_suffix)
    content_for(:title) { title_suffix }
  end
end
