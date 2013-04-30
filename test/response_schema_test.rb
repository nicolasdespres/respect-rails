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

  def test_duplicata_are_equal
    s = Respect::Rails::ResponseSchema.new(:ok)
    assert_equal s, s.dup
  end

  def test_differs_from_status
    s1 = Respect::Rails::ResponseSchema.new(:ok)
    s2 = Respect::Rails::ResponseSchema.new(:created)
    assert(s1 != s2)
  end

  def test_differs_from_body
    s1 = Respect::Rails::ResponseSchema.new
    s1.body = Respect::IntegerSchema.new
    s2 = Respect::Rails::ResponseSchema.new
    s2.body = Respect::StringSchema.new
    assert(s1 != s2)
  end

end
