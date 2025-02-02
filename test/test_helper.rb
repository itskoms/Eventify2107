require "simplecov"
SimpleCov.start "rails" do
  add_filter "/test/"
  add_filter "/config/"
  add_group "Controllers", "app/controllers"
  add_group "Models", "app/models"
  add_group "Views", "app/views"
  add_group "Helpers", "app/helpers"
  add_group "JavaScript", "app/javascript"
end

ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # Run tests in parallel with specified workers
    parallelize(workers: :number_of_processors, with: :threads)

    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
  end
end
