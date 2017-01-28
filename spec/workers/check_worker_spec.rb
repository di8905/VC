# frozen_string_literal: true
require "rails_helper"

RSpec.describe CheckWorker do
  let(:version) { "5.0.1" }
  let(:db_sha) { "123456" }
  let(:gem_path) { "gem file path" }

  it "opens file for sha calculation" do
    allow(File).to receive(:exist?).and_return(true)
    allow(File).to receive(:read).and_return("file body")
    expect(Digest::SHA256).to receive(:hexdigest).with(File.read(gem_path)).and_return("123456")

    CheckWorker.new.perform(version, gem_path, db_sha)
  end

  it "raises error if file does not exists" do
    allow(File).to receive(:exist?).and_return(false)

    expect { CheckWorker.new.perform(version, gem_path, db_sha) }.to raise_error("File does not exist")
  end

  it "raises error if given hash and file hash mismatch" do
    allow(File).to receive(:exist?).and_return(true)
    allow(File).to receive(:read).and_return("file body")
    allow(Digest::SHA256).to receive(:hexdigest).and_return("1111111")

    expect { CheckWorker.new.perform(version, gem_path, db_sha) }.to raise_error("Hashes do not match")
  end
end
