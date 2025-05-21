require 'capybara/rspec'

Capybara.register_driver :selenium_edge_wslg_headless do |app|
  options = Selenium::WebDriver::Edge::Options.new

  options.add_argument('--headless')
  options.add_argument('--disable-gpu')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')

  Capybara::Selenium::Driver.new(app, browser: :edge, options: options)
end

Capybara.register_driver :selenium_edge_wslg do |app|
  options = Selenium::WebDriver::Edge::Options.new

  options.add_argument('--disable-gpu')
  options.add_argument('--no-sandbox')
  options.add_argument('--disable-dev-shm-usage')

  Capybara::Selenium::Driver.new(app, browser: :edge, options: options)
end

Capybara.javascript_driver = :selenium_edge_wslg_headless

RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end

  config.before(:each, type: :system, js: true) do
    driven_by :selenium_edge_wslg_headless
  end
end