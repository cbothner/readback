module DjsHelper
  def interest_link(name)
    '<input type="button" class="interest-link" data-interest="'+name+'" value="'+
      name+'" />'
  end

  def interest_links(list)
    list.map{ |i| interest_link i }.join.html_safe
  end

  def needs_statement(trainee)
    trainee.um_affiliation == 'community' || !trainee.statement.blank?
  end

  def active_for_select(selected_dj)
    active_djs = Dj.where(active: true).order(:name)
    options_from_collection_for_select(active_djs, :id, :name, selected_dj.try(:id))
  end
end
