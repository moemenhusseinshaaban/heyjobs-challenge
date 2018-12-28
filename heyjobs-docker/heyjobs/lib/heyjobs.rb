require 'active_record'
require 'httparty'
require_relative 'heyjobs/config/app_config'
require_relative "heyjobs/services/sync_campaign_wth_ad_service"

require_relative 'heyjobs/helpers/heyjobs_helper'
include HeyjobsHelper

require_relative 'heyjobs/models/application_record.rb' # application_record abstract_class
require_relative 'heyjobs/models/campaign.rb' # campaigns table
require_relative 'heyjobs/models/job.rb' # jobs table
require_relative 'heyjobs/models/remote_ad.rb' # ad table


AppConfig.load

ActiveRecord::Base.establish_connection(AppConfig.database['development'])

module Heyjobs
end
