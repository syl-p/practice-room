class MediumUploader < Shrine
    plugin :download_endpoint, prefix: "uploads"
    Attacher.validate do
        validate_extension %w[jpg jpeg png webp mp4 pdf]
        validate_max_size 100*1024*1024 # 100 MB 
    end
end