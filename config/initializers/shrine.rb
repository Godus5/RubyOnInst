require "shrine"
require "shrine/storage/file_system"

Shrine.storages = {
  cache: Shrine::Storage::FileSystem.new("public", prefix: "uploads/cache"), # временное хранилище
  store: Shrine::Storage::FileSystem.new("public", prefix: "uploads/store") # постоянное хранилище
}

Shrine.plugin :activerecord
Shrine.plugin :cached_attachment_data # для сохранения данных о загруженных файлах между запросами формы
Shrine.plugin :restore_cached_data # восстанавливает данные о загруженных файлах из базы данных
