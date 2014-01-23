require 'spec_helper'

describe "the ht_crypt function" do
  let(:scope) { PuppetlabsSpec::PuppetInternals.scope }

  it "should exist" do
    Puppet::Parser::Functions.function("ht_crypt").should == "function_ht_crypt"
  end

  it "should raise a ParseError if there is less than 2 argument" do
    lambda { scope.function_ht_crypt(['test']) }.should( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if there is more than 2 arguments" do
    lambda { scope.function_ht_crypt(['foo', 'bar', 'ff']) }.should( raise_error(Puppet::ParseError))
  end

  it "should raise a ParseError if passed not a string" do
    lambda { scope.function_ht_crypt([42, 'str']) }.should( raise_error(Puppet::ParseError))
  end

  it "should return a Crypt password" do
    result = scope.function_ht_crypt(['testpassword', '46'])
    result.should(eq('46ursI0BCy7gc'))
  end
end
