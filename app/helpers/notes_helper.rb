require 'digest/md5'
module NotesHelper
  def color_for_string(string)
    Digest::MD5.hexdigest(string)[0..5]
  end
end
