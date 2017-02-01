require 'rails_helper'
require "shoulda/matchers"

RSpec.describe Picture, type: :model do
  it { should validate_presence_of :file }
end
