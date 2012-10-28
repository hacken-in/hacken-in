# encoding: utf-8

class AdvertisementUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  include Sprockets::Helpers::RailsHelper
  include Sprockets::Helpers::IsolatedHelper

  storage :file

  version :square do
    process :resize_to_fill => [304, 304]
  end

  version :rectangle do
    process :resize_to_fill => [299, 173]
  end

  version :wide_rectangle do
    process :resize_to_fill => [580, 74]
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end
end
