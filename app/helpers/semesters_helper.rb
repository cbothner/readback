module SemestersHelper
  def rowspan from, to
    unless to[:printable] == " 6:00 am"
      @start_times.select{|x| from[:sortable] <= x[:sortable] &&
                              x[:sortable]< to[:sortable] }.count
    else
      3
    end
  end

  def cache_key_for_semester(sem)
    id = sem.id
    max = [sem.freeform_shows.maximum(:updated_at),
           sem.specialty_shows.maximum(:updated_at),
           sem.talk_shows.maximum(:updated_at)]
      .max
      .try(:utc).try(:to_s, :number)
    "semesters/#{id}/#{max}"
  end

end
