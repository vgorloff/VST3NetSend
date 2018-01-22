require 'json'
require 'escape_utils'
require 'uri_template' # https://github.com/hannesg/uri_template
require_relative 'GitHub.rb'

class GitHubRepo < GitHub
  
  def initialize(user, repository)
    super()
    @user = user
    @repository = repository
    @endpoint = "#{@githubURL}/repos/#{@user}/#{@repository}"
  end
  
  def release(version, name, description)
    url = "#{@endpoint}/releases"
    body = { tag_name: version, name: name, body: description }.to_json
    response = post(url, body)
    releaseID = response['id']
    releaseURL = response['url']
    @releaseID = releaseID
    @releaseUploadURL = response['upload_url']
    puts "→ Release is created. ID: #{releaseID}, URL: #{releaseURL}."
    return releaseID
  end
  
  def uploadReleaseAsset(zipFilePath, uploadURL = nil)
    url = uploadURL ? uploadURL : @releaseUploadURL
    if !File.exists?(zipFilePath)
      raise "! File #{zipFilePath} is not exists."
    end
    if File.extname(zipFilePath) != ".zip"
      raise "! File #{zipFilePath} is ZIP-archive."
    end
    name = File.basename(zipFilePath)
    uri = URITemplate.new(url).expand :name => name # See also: https://developer.github.com/v3/#hypermedia
    response = attach(uri, zipFilePath)
    responseID = response['id']
    responseURL = response['url']
    puts "→ Uploaded asset. ID: #{responseID}, URL: #{responseURL}."
    return responseID
  end
  
  def deleteRelease(id)
    url = "#{@endpoint}/releases/#{id}"
    delete(url)
    @releaseID = nil
    @releaseUploadURL = nil
    puts "→ Deleted release. URL: #{url}."
  end
end
