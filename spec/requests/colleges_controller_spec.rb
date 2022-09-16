
require 'rails_helper'

RSpec.describe "College Controller", :type => :request do

  it "index shows the default page" do
    get "/"
    expect(response.body).to include("Search by college name:")
  end

  context "#search" do
    let(:school_location_mock) { double() }
    let(:mock_client) { instance_double(Client::CollegeScorecard, schools_locations: school_location_mock) }

    it "displays not found when no results found" do
      expect(school_location_mock).to receive(:body).and_return({"results" => []}.to_json)
      expect(school_location_mock).to receive(:status).and_return(200)

      expect(Client::CollegeScorecard).to receive(:new).and_return(mock_client)
      post("/colleges/search", params: {query: "Some College"})

      expect(response.body).to include("The college you entered was not found!")
    end

    it "displays result when the results are found" do
      expect(school_location_mock).to receive(:body).and_return({"results" => [{"location.lat"=> "10", "location.lon"=>"20"}]}.to_json)
      expect(school_location_mock).to receive(:status).and_return(200)

      expect(Client::CollegeScorecard).to receive(:new).and_return(mock_client)
      post("/colleges/search", params: {query: "Some College"})

      expect(response.body).to include("https://maps.googleapis.com")
    end
  end

end
