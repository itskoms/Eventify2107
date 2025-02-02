require "test_helper"

class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
  driven_by :selenium, using: :chrome, screen_size: [ 1400, 1400 ]

  def setup
    Capybara.app_host = "http://localhost"
  end
end
