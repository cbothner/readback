module SubRequestMailerHelper
  def duration_string_in_random_units(seconds)
    unit = %i(seconds minutes hours days).sample

    number = case unit
    when :seconds
      seconds
    when :minutes
      seconds / 60
    when :hours
      seconds / 60 / 60
    when :days
      seconds / 60 / 60 / 24
    end

    return "#{number_to_human(number).downcase} #{unit.to_s}"
  end
end
