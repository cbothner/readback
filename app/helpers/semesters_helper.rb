module SemestersHelper
  def rowspan from, to
    unless to[:printable] == " 6:00 am"
      @start_times.select{|x| from[:sortable] <= x[:sortable] &&
                              x[:sortable]< to[:sortable] }.count
    else
      3
    end
  end
end
