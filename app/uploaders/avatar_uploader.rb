# frozen_string_literal: true

class AvatarUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :file

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def default_url(*_args)
    '/images/fallback/avatar/' + [version_name, 'default.png'].compact.join('_')
  end

  version :thumb do
    process resize_to_fill: [100, 100]
  end

  def extension_whitelist
    %w[jpg jpeg gif png]
  end

  def size_range
    0..5.megabytes
  end

  # private

  # def check_extension_whitelist!(new_file)
  #   extension = new_file.extension.to_s
  #   if extension_whitelist && !whitelisted_extension?(extension)
  #     raise CarrierWave::IntegrityError, :incorrect_extension
  #   end
  # end
end
