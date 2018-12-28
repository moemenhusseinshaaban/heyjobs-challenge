class Campaign < ApplicationRecord
  # Relations
  belongs_to :job

  enum status: %i[active paused deleted]

  scope :remote_discrepancies, ->(job) do
    query = select("*, campaigns.status as local_status, remote_ads.status as remote_status, campaigns.id as campaign_id")
            .joins("FULL OUTER JOIN remote_ads ON campaigns.external_reference = remote_ads.reference")
            .where("campaigns.local_hash is null or remote_ads.remote_hash is null or remote_ads.remote_hash != campaigns.local_hash")
            .where.not("campaigns.status = #{Campaign.statuses['deleted']} and remote_ads.remote_hash is null")
    query = query.where("campaigns.job_id = #{job.id} or campaigns.id is null") if job.present?
    query
  end

  def self.status_key(value)
    statuses.key(value)
  end
end
