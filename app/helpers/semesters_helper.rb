module SemestersHelper
  def rowspan from, to
    @start_times.select{|x| from[:sortable] <= x[:sortable] &&
                            x[:sortable]< to[:sortable] }.count
  end
end
