# To change this license header, choose License Headers in Project Properties.
# To change this template file, choose Tools | Templates
# and open the template in the editor.

require 'net/http'
require 'json'

class GitHub
  
  ENV_VAR_KEY_GITHUB_TOKEN = 'AWL_GITHUB_TOKEN'

  def initialize()
    @githubURL = 'https://api.github.com'
    @accessToken = ENV[ENV_VAR_KEY_GITHUB_TOKEN]
    if @accessToken == nil
      raise "Github access token is missed. Please verify your environment."
    end
  end
  
  private
  def post(url, body)
    uri = URI.parse(url)
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{@accessToken}"
    request.body = body
    request.content_type = 'application/json'
    response = Net::HTTP.start(uri.hostname, uri.port, { use_ssl: true }) { |http| http.request(request) }
    return JSON.parse(response.body)
  end
  
  private
  def delete(url)
    uri = URI.parse(url)
    request = Net::HTTP::Delete.new(uri)
    request["Authorization"] = "Bearer #{@accessToken}"
    request.content_type = 'application/json'
    Net::HTTP.start(uri.hostname, uri.port, { use_ssl: true }) { |http| http.request(request) }
  end
  
  private
  def attach(url, zipFilePath)
    data = File.open(zipFilePath, "rb") { |f| f.read }
    uri = URI.parse(url)
    request = Net::HTTP::Post.new(uri)
    request["Authorization"] = "Bearer #{@accessToken}"
    request.content_type = 'application/zip'
    request.body = data
    response = Net::HTTP.start(uri.hostname, uri.port, { use_ssl: true }) { |http| http.request(request) }
    return JSON.parse(response.body)
  end
end
