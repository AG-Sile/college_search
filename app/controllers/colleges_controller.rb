require 'client/college_scorecard'

class CollegesController < ApplicationController

  def index
  end

  def search
    result = college_client.schools_locations(school_name: params["query"])
    parsed_body = JSON.parse(result.body)
    if result.status == 404 || parsed_body["results"].empty?
      render :not_found
    else
      map(parsed_body)
    end
  end

  private

  def map(parsed_body)
    @markers = parsed_body["results"].map do |result|
      lat = result["location.lat"]
      long = result["location.lon"]
      "#{lat},#{long}"
    end.join("|")
    render :map
  end

  def college_client
    @college_client ||= Client::CollegeScorecard.new
  end
end
