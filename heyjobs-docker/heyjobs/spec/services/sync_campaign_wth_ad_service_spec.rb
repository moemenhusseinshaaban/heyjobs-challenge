RSpec.describe Heyjobs::SyncCampaignWithAdService do
  include StubbedRequests::RemoteAdService
  describe 'Sync remote service with campaign' do
    before(:each) do
      stub_remote_ad_service
    end

    context 'First time request remote service' do
      it 'should have not local campaign data' do
        discrepancies = Heyjobs::SyncCampaignWithAdService.execute
        expect(discrepancies).to eq [discrepancies_result(1, RemoteAd.statuses["enabled"], nil, 'Description1', nil)].to_json
        hashed_data = hash_data(1, RemoteAd.statuses["enabled"], 'Description1')
        expect(Campaign.find_by(local_hash: hashed_data)).to be_present
      end

      it 'should create local campaign data for specific job' do
        Job.create(description: "Rails Developer")
        job_id = Job.first.id
        discrepancies = Heyjobs::SyncCampaignWithAdService.execute(job_id)
        expect(discrepancies).to eq [discrepancies_result(1, RemoteAd.statuses["enabled"], nil, 'Description1', nil)].to_json
        hashed_data = hash_data(1, RemoteAd.statuses["enabled"], 'Description1')
        expect(Campaign.find_by(job_id: job_id, local_hash: hashed_data)).to be_present
      end
    end

    context 'Local campaign has data' do
      it 'should update local campaign data if same external refrance data changed ' do
        local_hashed_data = hash_data(1, Campaign.statuses["paused"], 'Description2')
        remote_hashed_data = hash_data(1, RemoteAd.statuses["enabled"], 'Description1')
        Campaign.create(external_reference: 1, status: Campaign.statuses["paused"],
                        ad_description: 'Description2', local_hash: local_hashed_data)
        discrepancies = Heyjobs::SyncCampaignWithAdService.execute
        expect(discrepancies).to eq [
          discrepancies_result(1, RemoteAd.statuses["enabled"], Campaign.statuses["paused"], 'Description1', 'Description2')
        ].to_json
        expect(Campaign.find_by(local_hash: local_hashed_data)).not_to be_present
        expect(Campaign.find_by(local_hash: remote_hashed_data)).to be_present
      end

      it 'should assign non returned ad as deleted campaign if exists' do
        local_hashed_data = hash_data(2, Campaign.statuses["paused"], 'Description2')
        remote_hashed_data = hash_data(1, RemoteAd.statuses["enabled"], 'Description1')
        Campaign.create(external_reference: 2, status: Campaign.statuses["paused"],
                        ad_description: 'Description2', local_hash: local_hashed_data)
        discrepancies = Heyjobs::SyncCampaignWithAdService.execute
        expect(discrepancies).to eq [
          discrepancies_result(1, RemoteAd.statuses["enabled"], nil, 'Description1', nil),
          discrepancies_result(nil, nil, Campaign.statuses["paused"], nil, 'Description2')
        ].to_json
        expect(Campaign.deleted).to be_present
        expect(Campaign.find_by(local_hash: remote_hashed_data)).to be_present
      end
    end
  end
end
