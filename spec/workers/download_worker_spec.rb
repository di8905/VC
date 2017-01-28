# frozen_string_literal: true
require "rails_helper"

RSpec.describe DownloadWorker do
  let(:version) { "5.0.1" }
  let(:download_uri) { URI(DownloadWorker::DOWNLOAD_URL + version + ".gem") }
  let!(:response) { double }
  before do
    allow(response).to receive(:body).and_return("gemfile content")
    allow(response).to receive(:kind_of?).and_return(true)
    allow(Net::HTTP).to receive(:get_response).and_return(response)
    allow(File).to receive(:open).and_return("file")
  end

  it "requests gemfile" do
    allow(File).to receive(:open).and_return("file")
    expect(Net::HTTP).to receive(:get_response).with(download_uri).and_return(response)

    DownloadWorker.new.perform(version)
  end

  it "writes file" do
    expect(File).to receive(:open)
      .with("/home/di/ruby/vc/public/gems/" + version + ".gem", "wb")

    DownloadWorker.new.perform(version)
  end

  it "writes to db" do
    sha = Digest::SHA256.hexdigest("gemfile content")
    path = "/home/di/ruby/vc/public/gems/" + version + ".gem"
    query = "INSERT INTO versions (version, gem_copy, sha)
             VALUES (\'#{version}\', \'#{path}\', \'#{sha}\')"
    expect(ActiveRecord::Base.connection).to receive(:execute).with(query)

    DownloadWorker.new.perform(version)
  end
end
