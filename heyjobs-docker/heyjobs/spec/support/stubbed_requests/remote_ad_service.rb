module StubbedRequests
  module RemoteAdService
    AD_REMOTE_RESPONSE = {
      "ads":
      [
        {
          "reference": "1",
          "status": "enabled",
          "description": "Description1"
        }
      ]
    }.to_json

    def stub_remote_ad_service(response=nil)
      stub_request(:get, /#{AppConfig.ad_service}.*/)
        .to_return(
          status: 200,
          body: response || AD_REMOTE_RESPONSE,
          headers: { 'Content-Type' => 'application/json' }
        )
    end
  end
end
