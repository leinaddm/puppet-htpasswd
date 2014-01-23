require 'spec_helper'

describe "the ht_md5 function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("ht_md5").should == "function_ht_md5"
  end

  it "should raise a ParseError if there is less than 2 argument" do
    lambda { scope.function_ht_md5(['test']) }.should( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if there is more than 2 arguments" do
    lambda { scope.function_ht_md5(['foo', 'bar', 'ff']) }.should( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if passed not a string" do
    lambda { scope.function_ht_md5([42, 'str']) }.should( raise_error(Puppet::ParseError))
  end

  it "should return a MD5 password" do
    result = scope.function_ht_md5(['testpassword', 'PhT5FuSg'])
    result.should(eq('$apr1$PhT5FuSg$3o4QbIJfx4SZMLaa9T1A9.'))
  end
end
