require 'test_helper'

require 'minitest/spec'
require 'webmock/minitest'

require 'festivals_lab'

describe FestivalsLab do

  before do
    @api = FestivalsLab.new '123', '456'
    @successful_response = { status: 200, body: "[{}]", headers: { 'Content-Type' => 'application/json' } }
    @failed_response = { status: 403, body: "", headers: { 'Content-Type' => 'application/json' } }
  end

  it "has a VERSION" do
    FestivalsLab.constants.must_include :VERSION
  end

  describe "#initialize" do
    it "sets an access token" do
      api = FestivalsLab.new "123", nil

      api.access_key.must_equal "123"
    end

    it "sets an access key" do
      api = FestivalsLab.new nil, "456"

      api.secret_token.must_equal "456"
    end
  end

  describe "#events" do
    [:festival, :genre, :country, :code, :year, :title, :description, :artist, :venue_name, :post_code, :distance].each do |param|
      it "allows a string '#{param}' parameter" do
        stub = stub_http_request(:get, %r{//api\.festivalslab\.com/events})
          .with(query: hash_including(param => 'value'))
          .to_return(@successful_response)

        @api.events param => 'value'

        assert_requested(stub)
      end
    end

    [:venue_code, :price_from, :price_to, :size, :from, :lat, :lng].each do |param|
      it "allows a numeric '#{param}' parameter" do
        stub = stub_http_request(:get, %r{//api\.festivalslab\.com/events})
          .with(query: hash_including(param => '42'))
          .to_return(@successful_response)

        @api.events param => 42

        assert_requested(stub)
      end
    end

    [:date_from, :date_to, :modified_from].each do |param|
      it "allows a date '#{param}' parameter" do
        stub = stub_http_request(:get, %r{//api\.festivalslab\.com/events})
          .with(query: hash_including(param => '1970-01-01 01:00:00'))
          .to_return(@successful_response)

        @api.events param => Time.at(0).strftime("%F %T")

        assert_requested(stub)
      end
    end

    it "returns parsed events" do
      stub = stub_http_request(:get, %r{//api\.festivalslab\.com/events})
        .to_return(@successful_response)

      response = @api.events

      assert_equal [{}], response
    end

    it "rejects invalid parameters" do
      lambda {
        @api.events foobar: 42
      }.must_raise(FestivalsLab::ArgumentError, "Unexpected events parameter: foobar")
    end
  end

  describe "request" do
    before do
      @uri = "http://api.festivalslab.com/events?key=123&signature=742969faae86a4ba4223c7d93d05ead4b1397c23"
    end

    it "makes a request to the signed endpoint URI" do
      stub_request(:get, @uri).to_return(@successful_response)

      FestivalsLab.request @api.access_key, @api.secret_token, '/events'

      assert_requested(:get, @uri)
    end

    it "parses the response as JSON" do
      stub = stub_http_request(:get, @uri)
        .to_return(@successful_response)

      response = FestivalsLab.request @api.access_key, @api.secret_token, '/events'

      assert_equal [{}], response
    end

    it "raises FestivalsLab::ApiError on unsuccessful HTTP request" do
      stub = stub_http_request(:get, @uri)
        .to_return(@failed_response)

      lambda { FestivalsLab.request @api.access_key, @api.secret_token, '/events' }.must_raise(FestivalsLab::ApiError)
    end
  end

  describe "signed_uri" do
    it "requires an access key to be set" do
      @api.secret_token = nil
      lambda { FestivalsLab.signed_uri(@api.access_key, @api.secret_token, '/events') }.must_raise(FestivalsLab::Error, "Missing API access key")
    end

    it "requires an access token to be set" do
      @api.access_key = nil
      lambda { FestivalsLab.signed_uri(@api.access_key, @api.secret_token, '/events') }.must_raise(FestivalsLab::Error, "Missing API access token")
    end

    it "appends the correct signature to the request URI" do
      uri = FestivalsLab.signed_uri(@api.access_key, @api.secret_token, '/events', {:key => 123})
      uri.must_be_kind_of(URI)
      uri.to_s.must_equal 'http://api.festivalslab.com/events?key=123&signature=742969faae86a4ba4223c7d93d05ead4b1397c23'
    end
  end

  describe "signature" do
    it "calculates the HMAC-SHA1 signature based on the access key" do
      ## Because `OpenSSL#HMAC.hexdigest('sha1', '456', '/events?key=123')` # => '742969faae86a4ba4223c7d93d05ead4b1397c23'
      FestivalsLab.signature(@api.secret_token, '/events?key=123').must_equal '742969faae86a4ba4223c7d93d05ead4b1397c23'
    end
  end

end


