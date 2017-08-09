# frozen_string_literal: true

module ApplicationHelper
  LATEX_SUBSTITUTIONS = { '“': '``', '”': "''", '‘': '`', '’': "'" }.freeze

  # TODO
  def page_path(*_args)
    '/'
  end

  def events_path
    '/'
  end

  def parent_layout(layout)
    @view_flow.set(:layout, output_buffer)
    self.output_buffer = render(file: "layouts/#{layout}")
  end

  def lesc(text = '')
    escaped = text.gsub(/./) do |char|
      next char unless LATEX_SUBSTITUTIONS.key? char

      LATEX_SUBSTITUTIONS[char]
    end

    LatexToPdf.escape_latex escaped
  end

  %i[title headline back_link subtitle]
    .each do |key|
    ApplicationHelper.send(:define_method, key) do |val|
      content_for(key) { val }
    end
  end

  def markdown(text)
    text ||= ''

    extensions = {
      no_intra_emphasis: true,
      autolink: true,
      disable_indented_code_blocks: true
    }
    renderer = Redcarpet::Render::HTML.new(
      hard_wrap: true,
      link_attributes: { target: '_blank' }
    )
    markdown = Redcarpet::Markdown.new(renderer, extensions)

    markdown.render(text).html_safe
  end

  def on_fm_computer?
    playlist_editor_signed_in?
  end

  def external_link_to(*args, **kwargs, &blk)
    link_to(
      *args,
      **kwargs.merge(target: '_blank', rel: 'noopener noreferrer'),
      &blk
    )
  end

  def theme_colors
    <<~CSS.squish
      --color-primary--rgb: #{theme.primary.bright};
      --color-primary--dark--rgb: #{theme.primary.dark};
      --color-primary__contrast--rgb: #{theme.primary.contrast};

      --color-accent--rgb: #{theme.accent.bright};
      --color-accent--dark--rgb: #{theme.accent.dark};
      --color-accent__contrast--rgb: #{theme.accent.contrast};

      --white--rgb: #{Color.white.bright};
      --black--rgb: #{Color.black.dark};
    CSS
  end

  def user_signed_in?
    dj_signed_in? || trainee_signed_in?
  end
end
