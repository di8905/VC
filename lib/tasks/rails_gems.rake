# frozen_string_literal: true
# VersionsChecker in app/services
# DownloadWorker and CheckWorker in app/workers

URL = "https://rubygems.org/api/v1/versions/rails.json"

namespace :rails do
  desc "Downloads and checks all rails gems versions"
  task versions: :environment do
    @response = Net::HTTP.get_response URI(URL)
    @versions = JSON.parse(@response.body)
    VersionsChecker.new(@versions).check_list
  end

  desc "Cleans gem versions table in db"
  task db_clean: :environment do
    ActiveRecord::Base.connection.execute "DELETE FROM versions"
  end

  desc "Clears downloaded gems folder"
  task :gemfile_clr do
    `rm /home/di/ruby/vc/public/gems/*`
  end

  desc "Clears db and folder from gems versions"
  task clr: %i(db_clean gemfile_clr) do
  end

  desc "Shows versions db content"
  task db_show: :environment do
    puts ActiveRecord::Base.connection.execute "SELECT * FROM versions"
  end
end
