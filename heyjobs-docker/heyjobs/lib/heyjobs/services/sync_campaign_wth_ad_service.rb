module Heyjobs
  class SyncCampaignWithAdService

    def initialize(job_id)
      @job_id = job_id
    end

    def self.execute(job_id = nil)
      new(job_id).execute
    end

    def execute
      save_remote_ads
      detect_discrepancies Campaign.remote_discrepancies(job)
    end

    private

    attr_reader :job_id

    def job
      @job ||= Job.find_by(id: job_id)
    end

    def export_ad_service
      JSON.parse(HTTParty.get(AppConfig.ad_service).body)
    end

    def save_remote_ads
      export_ad_service["ads"].each do |ad|
        RemoteAd.create({
          reference: ad["reference"],
          status: RemoteAd.statuses[ad["status"]],
          description: ad["description"],
          remote_hash: hash_data(ad["reference"], RemoteAd.statuses[ad["status"]], ad["description"])
        })
      end
    end

    def detect_discrepancies(discrepancies)
      result = []
      discrepancies.each do |object|
        result << discrepancies_result(object.reference, object.remote_status, object.local_status, object.description, object.ad_description)
        update_campaigns object
      end
      RemoteAd.destroy_all
      result.to_json
    end

    def update_campaigns(object)
      if object.remote_hash.present? && object.local_hash.present? # If campaign is updated
        Campaign.update(object.campaign_id, status: object.remote_status, ad_description: object.description, local_hash: object.remote_hash)
      elsif object.remote_hash.nil? && object.local_status  # If campaign is deleted
        Campaign.find(object.campaign_id).deleted!
      elsif object.local_hash.nil? # If new campaign is created
        Campaign.create(job: job, external_reference: object.reference, status: object.remote_status,
                        ad_description: object.description, local_hash: object.remote_hash)
      end
    end
  end
end
