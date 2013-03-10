class PictureUploader < AbstractUploader
  version :thumb do
    process :resize_to_fill => [50, 50]
  end

  version :small do
    process :resize_to_fill => [307, 177]
  end
end
