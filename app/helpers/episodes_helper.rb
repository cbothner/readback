module EpisodesHelper
  def with(ep)
    dj_name = link_to(ep.active_dj, ep.active_dj).html_safe
    case ep.show_type
    when "FreeformShow" then
      "with #{"Guest DJ" if ep.subbed_for?} #{dj_name}".html_safe
    when "SpecialtyShow" then
      "with #{ep.unassigned? ? "coordinator" : "rotating host"} #{dj_name}".html_safe
    when "TalkShow" then
      "a WCBN public affairs show#{" with your host, #{dj_name}".html_safe unless ep.show.dj.nil?}".html_safe
    end
  end
end
