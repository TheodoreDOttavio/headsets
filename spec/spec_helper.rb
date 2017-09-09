=begin
require 'rubygems'
require 'spork'

#uncomment the following line to use spork with the debugger
#require 'spork/ext/ruby-debug'

#Spork.prefork do
  # Loading more in this block will cause your tests to run faster.
  # need to restart spork for it take effect.

  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'rspec/autorun'

  # Requires supporting ruby files in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each { |f| require f }

  # Checks for/runs pending migrations before testing.
  ActiveRecord::Migration.check_pending! if defined?(ActiveRecord::Migration)
  # an alternate way to write this: ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    # This option will default to `true` in RSpec 4. It makes the `description`
    # and `failure_message` of custom matchers include text for helper methods
    # defined using `chain`, e.g.:
    #     be_bigger_than(2).and_smaller_than(4).description
    #     # => "be bigger than 2 and smaller than 4"
    # ...rather than:
    #     # => "be bigger than 2"
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks config goes here. You can use an alternate test double
  # library (such as bogus or mocha) by changing the `mock_with` option here.
  config.mock_with :rspec do |mocks|
    # Prevents you from mocking or stubbing a method that does not exist on
    # a real object. This is generally recommended, and will default to
    # `true` in RSpec 4.
    mocks.verify_partial_doubles = true
  end

  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  #uses ActiveRecord and allows each example to run with a transaction
  config.use_transactional_fixtures = true

  # Base class of anonymous controllers will be inferred automatically.
  #  This will be the default behavior in future versions of rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  config.order = "random"

  config.include Capybara::DSL
end

#end #spork.prefork


#Spork.each_run do
  # This code will be run each time you run your specs.
#end
=end
