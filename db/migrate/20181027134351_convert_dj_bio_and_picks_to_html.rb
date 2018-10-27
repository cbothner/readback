# frozen_string_literal: true

class ConvertDjBioAndPicksToHtml < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up { convert }
    end
  end

  private

  def convert
    Dj.find_each do |dj|
      dj.update_columns about: html(dj.about), lists: html(dj.lists)
    end
  end

  def html(text)
    text ||= ''
    dingus.render(text)
  end

  def dingus
    @renderer ||= Redcarpet::Render::HTML.new renderer_config
    @dingus ||= Redcarpet::Markdown.new @renderer, markdown_extensions
  end

  def renderer_config
    { hard_wrap: true, link_attributes: { target: '_blank' } }
  end

  def markdown_extensions
    {
      no_intra_emphasis: true,
      autolink: true,
      disable_indented_code_blocks: true
    }
  end
end
