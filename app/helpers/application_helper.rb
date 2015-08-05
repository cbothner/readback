module ApplicationHelper
  def parent_layout(layout)
    @view_flow.set(:layout, output_buffer)
    self.output_buffer = render(file: "layouts/#{layout}")
  end

  def lesc(text)
    text ||= ''
    [['“', '``'], ['”', "''"], ['‘', '`'], ['’', "'"]].each do |a, b|
      text.sub! a, b
    end
    LatexToPdf.escape_latex(text)
  end

  %i(title headline back_link subtitle)
    .each do |key|
    ApplicationHelper.send(:define_method, key) do |val|
      content_for(key) { val }
    end
  end

  def markdown(text)
    text ||= ''
    markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML.new(hard_wrap: true),
                                       no_intra_emphasis: true, autolink: true,
                                       disable_indented_code_blocks: true)
    markdown.render(text).html_safe
  end
  
  def on_fm_computer?
    playlist_editor_signed_in?
  end
end
