class AdvertisementUploader < AbstractUploader
  version :square do
    process :resize_to_fill => [304, 304]
  end

  version :rectangle do
    process :resize_to_fill => [299, 173]
  end

  version :wide_rectangle do
    process :resize_to_fill => [580, 74]
  end
end
