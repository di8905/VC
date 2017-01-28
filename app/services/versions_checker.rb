# frozen_string_literal: true
class VersionsChecker
  def initialize(list)
    @list = list
    @log = ActiveSupport::Logger.new("log/versions.log")
  end

  def query_db(version)
    query = <<~SQL
             SELECT version, gem_copy, sha
             FROM versions
             WHERE version = \'#{version}\'
             SQL
    ActiveRecord::Base.connection.execute query
  end

  def check_list
    @list.each do |record|
      search = query_db(record["number"])
      if search.nil? || search.empty?
        @log.info("Record not found, downloading version #{record['number']} ")
        DownloadWorker.perform_async(record["number"])
      else
        @log.info("Record version #{record['number']} found, checking")
        version, gem_copy, db_sha = search.flatten
        CheckWorker.perform_async(version, gem_copy, db_sha)
      end
    end
    @log.close
  end
end
