# frozen_string_literal: true

require 'uri'
require 'net/http'
require 'json'
require 'base64'
require 'date'

module Ghrt
  class Github
    def initialize(repo, verbose)
      @repo = repo
      @username = ENV['GITHUB_USERNAME']
      @token = ENV['GITHUB_TOKEN']
      raise 'GITHUB_USERNAME and GITHUB_TOKEN environment variables must be set' unless @username && @token

      @verbose = verbose
    end

    def review_comments(pull_request, since)
      response = []
      page = 1

      loop do
        paged_response = query_github("/pulls/#{pull_request}/comments?since=#{since}&per_page=100&page=#{page}")
        break if paged_response.empty?

        response.concat(paged_response)
        page += 1
      end

      response.select do |comment|
        comment['user']['login'] == @username &&
        DateTime.parse(comment['created_at']) >= DateTime.parse(since) if since
      end
    end

    private

    def query_github(path)
      url = URI("https://api.github.com/repos/#{@repo}#{path}")
      puts url if @verbose

      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true

      request = Net::HTTP::Get.new(url)
      request['Authorization'] = auth_header

      parse_response(http.request(request))
    end

    def parse_response(response)
      puts response.code if @verbose
      raise "Unexpected API response status #{response.code}" unless response.code == '200'

      JSON.parse(response.read_body)
    end

    def auth_header
      auth_header = "Basic #{Base64.urlsafe_encode64("#{@username}:#{@token}")}"
      puts auth_header if @verbose
      auth_header
    end

    def validate_envars
      return unless ENV['GITHUB_USERNAME'] && ENV['GITHUB_TOKEN']

      raise 'GITHUB_USERNAME and GITHUB_TOKEN environment variables have not been set'
    end
  end
end
