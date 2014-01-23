require 'spec_helper'

describe "the ht_sha1 function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("ht_sha1").should == "function_ht_sha1"
  end

  it "should raise a ParseError if there is less than 1 argument" do
    lambda { scope.function_ht_sha1([]) }.should( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if there is more than 1 argument" do
    lambda { scope.function_ht_sha1(['foo', 'bar']) }.should( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if passed not a string" do
    lambda { scope.function_ht_sha1([42]) }.should( raise_error(Puppet::ParseError))
  end

  it "should return a SHA1 password" do
    result = scope.function_ht_sha1(['testpassword'])
    result.should(eq('{SHA}i7YRj4/Wk1rQh2o740pxfTJwj/0='))
  end
end
