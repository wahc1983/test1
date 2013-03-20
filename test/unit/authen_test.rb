require 'test_helper'

class AuthenTest < ActiveSupport::TestCase
  def test_should_be_valid
    assert Authen.new.valid?
  end
end
