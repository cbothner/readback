module ApplicationHelper
  def parent_layout(layout)
    @view_flow.set(:layout, output_buffer)
    self.output_buffer = render(file: "layouts/#{layout}")
  end
  
  def title(title_suffix)
    content_for(:title) { title_suffix }
  end

  def headline(headline)
    content_for(:headline) { headline }
  end

  def back_link(back_link)
    content_for(:back_link) { back_link }
  end
end
