require "shrine"
require "shrine/storage/file_system"
require "image_processing/mini_magick"

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # temporary
  store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store") # permanent
}

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # for retaining the cached file across form redisplays
Shrine.plugin :restore_cached_data # re-extract metadata when attaching a cached file
Shrine.plugin :validation_helpers

class PhotoUploader < Shrine
  include ImageProcessing::MiniMagick

  plugin :processing
  plugin :versions, names: [:original, :thumb]
  plugin :delete_raw # delete processed files after uploading

  process(:store) do |io, context|
    original = io.download
    thumb = ImageProcessing::MiniMagick.source(original).resize_to_limit(300, 300).call
    {original: io, thumb: thumb}
  end
end
