require 'json'
require 'net/http'
require 'openssl' # Provides HMAC-SHA1

class FestivalsLab

  attr_accessor :access_key, :secret_token

  SCHEME = "http"
  HOST = "api.festivalslab.com"

  def initialize access_key, secret_token
    @access_key   = access_key
    @secret_token = secret_token
  end

  def events params = {}
    params = params.dup

    # Exact field options
    valid_options = [:festival, :genre, :country, :code, :year]
    # Fulltext search options
    valid_options += [:title, :description, :artist]
    # Event date options
    valid_options += [:date_from, :date_to]
    # Venue options
    valid_options += [:venue_name, :venue_code, :post_code, :distance, :lat, :lng]
    # Price options
    valid_options += [:price_from, :price_to]
    # Update options
    valid_options += [:modified_from]
    # Pagination options
    valid_options += [:size, :from]

    invalid_keys = params.reject { |k,v| valid_options.include? k }.keys

    raise ArgumentError, "Unexpected events parameter: #{invalid_keys.join ", "}" if invalid_keys.any?

    FestivalsLab.request access_key, secret_token, '/events', params
  end

  class << self
    def request access_key, secret_token, endpoint, params = {}
      uri = FestivalsLab.signed_uri access_key, secret_token, endpoint, params
      Net::HTTP.start(uri.host, uri.port) do |http|
        request = Net::HTTP::Get.new uri.request_uri
        request['Accept'] = 'application/json'
        response = http.request request
        if Net::HTTPSuccess === response
          JSON.parse(response.body)
        else
          raise ApiError.new(response)
        end
      end
    end

    def signed_uri access_key, secret_token, endpoint, params = {}
      params = params.dup
      raise Error, "Missing API access key" unless access_key
      raise Error, "Missing API secret token" unless secret_token
      # Start with a generic URI representing just the path
      # This is convenient because the URI represents the string which gets signed
      uri = URI(endpoint)

      params[:key] = access_key
      uri.query = URI.encode_www_form(params)

      params[:signature] = FestivalsLab.signature secret_token, uri.to_s
      uri.query = URI.encode_www_form(params)

      uri.scheme = SCHEME
      uri.host   = HOST
      # Now the URI has a scheme we can convert it to an actual URI::HTTP
      URI.parse(uri.to_s)
    end

    def signature secret_token, url
      OpenSSL::HMAC.hexdigest 'sha1', secret_token, url
    end
  end


  Error = Class.new(StandardError)
  ArgumentError = Class.new(::ArgumentError)
  ApiError = Class.new(StandardError) do
    attr_reader :response

    def initialize response
      @response = response
    end
  end
end
