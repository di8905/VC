# frozen_string_literal: true
class AddFileToPicture < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :file, :string
  end
end
