# frozen_string_literal: true
require "digest"
require "sqlite3"

class CheckWorker
  include Sidekiq::Worker

  def perform(_version, db_gem_path, db_sha)
    raise "File does not exist" unless File.exist?(db_gem_path)
    file_sha = Digest::SHA256.hexdigest(File.read(db_gem_path))
    raise "Hashes do not match" unless file_sha == db_sha
  end
end
