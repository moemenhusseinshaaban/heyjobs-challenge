class RemoteAd < ApplicationRecord
  # Relations
  enum status: %i[enabled disabled]

  def self.status_key(value)
    statuses.key(value)
  end
end
