module HeyjobsHelper
  def discrepancies_result(reference_id, remote_status, local_status, remote_description, local_description)
    {
      "remote_reference": reference_id,
      "discrepancies": [
        "status": {
          "remote": RemoteAd.status_key(remote_status),
          "local": Campaign.status_key(local_status)
        },
        "description": {
          "remote": remote_description,
          "local": local_description
        }
      ]
    }
  end

  def hash_data(id, status, description)
    Digest::MD5.hexdigest("#{id}#{status}#{description}")
  end
end
