require 'spec_helper'

describe "ht_md5" do

  it "should exist" do
    Puppet::Parser::Functions.function("ht_md5").should == "function_ht_md5"
  end

  it "should raise a ParseError if there is less than 2 argument" do
    is_expected.to run.with_params('testpassword').and_raise_error(Puppet::ParseError)
  end

  it "should raise a ParseError if there is more than 2 arguments" do
    is_expected.to run.with_params('foo', 'bar', 'baz').and_raise_error(Puppet::ParseError)
  end

  it "should raise a ParseError if passed not a string" do
    is_expected.to run.with_params(42, 'str').and_raise_error(Puppet::ParseError)
  end

  it "should return a MD5 password" do
    is_expected.to run.with_params('testpassword', 'PhT5FuSg').and_return('$apr1$PhT5FuSg$3o4QbIJfx4SZMLaa9T1A9.')
  end
end
