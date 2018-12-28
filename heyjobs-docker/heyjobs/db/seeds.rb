Job.create(description: "Rails Engineer") if Job.count == 0
if Campaign.count == 0
  job = Job.first
  Campaign.create(
    [
      {
        status: Campaign.statuses["active"],
        job: job,
        external_reference: 1,
        ad_description: "Description for campaign 11",
        local_hash: hash_data("1", Campaign.statuses["active"], "Description for campaign 11")
      },
      {
        status: Campaign.statuses["active"],
        job: job,
        external_reference: 2,
        ad_description: "Description for campaign 17",
        local_hash: hash_data("2", Campaign.statuses["active"], "Description for campaign 17")
      },
      {
        status: Campaign.statuses["paused"],
        job: job,
        external_reference: 4,
        ad_description: "Description for campaign 25",
        local_hash: hash_data("4", Campaign.statuses["paused"], "Description for campaign 25")
      }
    ])
  p "#{DateTime.now} Campaigns Successfully Created"
end
