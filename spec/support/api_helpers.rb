module ApiHelpers
  def expect_api_response(expected_json)
    expect(response).to have_http_status 200
    expect(response.content_type).to eq 'application/json'
    
    expect(response.body).to be_json_eql(expected_json)
  end

  def json_response
    JSON.parse(response.body)
  end
end