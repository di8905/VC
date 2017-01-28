# frozen_string_literal: true
require "rails_helper"

RSpec.describe VersionsChecker do
  let(:list) { [{"number" => "5.0.1"}, {"number" => "5.0.2"}] }
  let(:version) { "5.0.1" }
  let(:query) {
    "SELECT version, gem_copy, sha
                 FROM versions
                 WHERE version = \'#{version}\'"
  }
  before do
    ActiveRecord::Base.connection.execute <<~SQL
      create table if not exists versions (
        ID INTEGER PRIMARY KEY ,
        VERSION varchar(10) NOT NULL,
        GEM_COPY varchar NOT NULL,
        SHA varchar(64) NOT NULL);
       DELETE FROM versions;
       INSERT INTO versions version, gem_copy, sha
       VALUES '5.0.1', 'testpath.gem', 'test sha';
    SQL
  end

  it "queries db with every list record" do
    list.each do |record|
      expect(ActiveRecord::Base.connection)
        .to receive(:execute)
        .with <<~SQL
                 SELECT version, gem_copy, sha
                 FROM versions
                 WHERE version = \'#{record['number']}\'
                 SQL
    end

    VersionsChecker.new(list).check_list
  end

  it "invokes download worker if record not found" do
    expect(DownloadWorker).to receive(:perform_async).with("some version")

    VersionsChecker.new(["number" => "some version"]).check_list
  end

  it "invokes check worker if record found" do
    allow(ActiveRecord::Base.connection).to receive(:execute).and_return(["5.0.1", "testpath.gem", "test sha"])
    expect(CheckWorker).to receive(:perform_async).with("5.0.1", "testpath.gem", "test sha")

    VersionsChecker.new(["number" => "5.0.1"]).check_list
  end
end
