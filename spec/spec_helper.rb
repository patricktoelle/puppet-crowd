require 'puppetlabs_spec_helper/module_spec_helper'
require 'rspec-puppet-facts'
include RspecPuppetFacts

RSpec.configure do |c|
  c.before :each do
    # Ensure that we don't accidentally cache facts and environment
    # between test cases.
    Facter.clear
    Facter.clear_messages
  end
end
