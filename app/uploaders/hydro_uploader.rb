class HydroUploader < CarrierWave::Uploader::Base
  storage :fog

  def store_dir
    "hydro_uploads"
  end

  def extension_white_list
    %w(xls)
  end
end
