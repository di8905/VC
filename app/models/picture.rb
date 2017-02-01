# frozen_string_literal: true
class Picture < ApplicationRecord
  extend Dragonfly::Model::Validations

  dragonfly_accessor :file do
    after_assign { |img| img.thumb!('100x100') }
  end

  validates :file, presence: true
end
