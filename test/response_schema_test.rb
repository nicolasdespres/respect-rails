require "test_helper"

class ResponseSchemaTest < Test::Unit::TestCase
  def test_define_with_block
    s = Respect::ObjectSchema.define do |s|
      s.integer "result"
    end
    block_def = Proc.new do
      body_with_object do |s|
        s.integer "result"
      end
    end
    rs = Respect::Rails::ResponseSchema.define(:ok, &block_def)
    assert_equal :ok, rs.status
    assert_equal s, rs.body

    rs = Respect::Rails::ResponseSchema.define(&block_def)
    assert_equal :ok, rs.status
    assert_equal s, rs.body
  end

end
