class Mp3Uploader < AbstractUploader
  def extension_white_list
    %w(mp3)
  end
end
