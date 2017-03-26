class HydroUploader < CarrierWave::Uploader::Base

  # if Rails.env.production?
    storage :fog
  # elsif Rails.env.development?
    # storage :file
  # end

  def store_dir
    "hydro_uploads"
  end

  def extension_white_list
    %w(xls)
  end
end
