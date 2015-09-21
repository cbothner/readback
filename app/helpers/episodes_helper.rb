module EpisodesHelper
  def with(ep, short:false)
    dj_name = link_to(ep.active_dj, ep.active_dj).html_safe
    case ep.show_type
    when "FreeformShow" then
      "with #{"Guest DJ" if ep.subbed_for?} #{dj_name}".html_safe
    when "SpecialtyShow" then
      "with rotating host #{dj_name}".html_safe
    when "TalkShow" then
      wcbn_pa = with = ""
      wcbn_pa = "a WCBN public affairs show" unless short
      your_or_guest = ep.subbed_for? ? "guest" : "your"
      with = "with #{your_or_guest} host, #{dj_name}" unless ep.show.dj.nil?
      raw wcbn_pa + " " + with
    end
  end
end
