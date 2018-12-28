require "heyjobs"
require "webmock/rspec"
require "support/stubbed_requests/remote_ad_service"
ActiveRecord::Base.establish_connection(AppConfig.database['test'])

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
  config.before(:each) do
    Campaign.destroy_all
  end
end
