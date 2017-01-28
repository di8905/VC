# frozen_string_literal: true
class CreateVersions < ActiveRecord::Migration[5.0]
  def change
    create_table :versions do |t|
      t.string :version
      t.string :gem_copy
      t.string :sha, limit: 64
    end
  end
end
