module Person

  AFFILIATED_UM_AFFILIATIONS = %w(student alumni faculty)
  UNAFFILIATED_UM_AFFILIATIONS = %w(community)
  UM_AFFILIATIONS = AFFILIATED_UM_AFFILIATIONS + UNAFFILIATED_UM_AFFILIATIONS
  AFFILIATION_NAMES = {'student' => "Student", 'alumni' => "Alumni",
                       'faculty' => "Faculty/Staff", 'community' => "Community Advisor"}

  def um_affiliated?
    AFFILIATED_UM_AFFILIATIONS.include? um_affiliation
  end

  def um_id
    s = umid.to_s
    "#{s[0..3]}&nbsp;#{s[4..7]}".html_safe
  end

  def first_name
    name.split(' ').first
  end

  def name_and_email
    "#{name} <#{email}>"
  end

  def to_s
    first_name
  end

end
