# frozen_string_literal: true
class AddPictureAttributes < ActiveRecord::Migration[5.0]
  def change
    add_column :pictures, :file_uid,  :string
    add_column :pictures, :file_name, :string
  end
end
