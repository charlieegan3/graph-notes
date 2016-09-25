require 'digest/md5'
module NotesHelper
  def color_for_string(string)
    Digest::MD5.hexdigest(string)[0..5]
  end

  def compact_age(created_at)
    distance_of_time_in_words(created_at, Time.now)
      .gsub(/seconds?/, "s")
      .gsub(/minutes?/, "m")
      .gsub(/hours?/, "h")
      .gsub(/days?/, "d")
      .gsub("less than a", "1")
      .gsub("about", "")
      .gsub(/\s+/, "")
  end
end
