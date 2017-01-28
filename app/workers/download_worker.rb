# frozen_string_literal: true
require "sidekiq"
require "net/http"
require "sqlite3"
require "digest"

class DownloadWorker
  include Sidekiq::Worker

  DOWNLOAD_URL = "https://rubygems.org/downloads/rails-"
  GEMS_PATH = "/home/di/ruby/vc/public/gems/"

  def perform(version)
    response = Net::HTTP.get_response(URI(DOWNLOAD_URL + version + ".gem"))
    gemfile = response.kind_of?(Net::HTTPSuccess) ? response.body : nil
    raise "Cannot fetch gemfile" if !gemfile || gemfile.empty?
    path = GEMS_PATH + version + ".gem"
    sha = Digest::SHA256.hexdigest(gemfile)
    File.open(path, "wb") do |file|
      file.write(gemfile)
    end
    write_to_db(version, path, sha)
  end

  private

  def write_to_db(version, path, sha)
    query = "INSERT INTO versions (version, gem_copy, sha)
             VALUES (\'#{version}\', \'#{path}\', \'#{sha}\')"
    ActiveRecord::Base.connection.execute query
  end
end
