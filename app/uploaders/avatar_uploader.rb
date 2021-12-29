class AvatarUploader < Shrine
  plugin :download_endpoint, prefix: "uploads"
  Attacher.validate do
    validate_mime_type %w[image/jpeg image/jpg image/png image/webp]
    validate_max_size  1*1024*1024
  end
end
