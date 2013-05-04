require 'test_helper'

class SkippedAutomaticValidationControllerTest < ActionController::TestCase

  def test_basic_get_works
    assert_raises(RuntimeError) do
      # The schema say that 42 is expected for param1, not 51.
      get :basic_get, format: 'json', param1: 51
    end
  end

end
