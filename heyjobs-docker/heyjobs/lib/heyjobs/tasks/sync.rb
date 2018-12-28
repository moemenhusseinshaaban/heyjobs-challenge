namespace :sync do
  desc "Syncing campaigns of specific job"
  task :campaigns, %i[job_id] do |task, args|
    job_id = args[:job_id] || Job.first.id
    p Heyjobs::SyncCampaignWithAdService.execute(job_id)
  end
end
