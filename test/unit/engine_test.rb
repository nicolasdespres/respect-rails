require "test_helper"

class EngineTest < ActiveSupport::TestCase
  def test_doc_app_name
    assert_equal "Dummy", Respect::Rails::Engine.doc_app_name
  end
end
