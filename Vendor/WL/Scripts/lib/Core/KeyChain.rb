require_relative 'Tool.rb'

class KeyChain

  def initialize(nameOrPath, password)
    @nameOrPath = nameOrPath
    @password = password
  end
  
  def nameOrPath()
    return @nameOrPath
  end
  
  def self.defaultName()
    return 'WaveLabsAutomation.keychain'
  end
  
  def self.randomPassword()
    require 'securerandom'
    return SecureRandom.base64
  end

  def self.list()
    result = `#{exe} list-keychains`.split("\n")
    result = result.map { |s| cleanupFilePath(s) }
    return result
  end
  
  def self.default()
    result = `#{exe} default-keychain`
    result = cleanupFilePath(result)
    return result
  end
  
  def self.login()
    result = `#{exe} login-keychain`
    result = cleanupFilePath(result)
    return result
  end
  
  def self.create(nameOrPath = nil, password = nil)
    pass = password ? password : randomPassword()
    name = nameOrPath ? nameOrPath : defaultName()
    cmd = "#{exe} create-keychain -p #{pass} #{name}"
    system(cmd)
    # Line below solves macOS bug: See https://stackoverflow.com/a/22234506/1418981
    cmd = "#{exe} list-keychains -d user -s login.keychain #{name}"
    system(cmd)
    result = list().select { |f| f.include?(name) }.first
    puts "* Created keychain \"#{result}\""
    result = KeyChain.new(result, pass)
    return result
  end
  
  def self.delete(nameOrPath)
    puts "- Deleting keychain: \"#{nameOrPath}\""
    cmd = "#{exe} delete-keychain #{nameOrPath}"
    system(cmd)
  end
  
  def self.setDefault(nameOrPath)
    puts "- Making default keychain: \"#{nameOrPath}\""
    cmd = "#{exe} default-keychain -s #{nameOrPath}"
    system(cmd)
  end
  
  def lock()
    cmd = "#{exe} lock-keychain \"#{@nameOrPath}\""
    system(cmd)
  end
  
  def unlock()
    cmd = "#{exe} unlock-keychain -p #{@password} \"#{@nameOrPath}\""
    system(cmd)
  end
  
  def import(filePath, passphrase, tools = nil)
    tools = tools ? tools : []
    toolsOptions = tools.map { |t| "-T #{t}" }.join(" ")
    cmd = "#{exe} import #{filePath} -k \"#{@nameOrPath}\" -P #{passphrase} #{toolsOptions}"
    system(cmd)
  end
  
  def setSettings(isLockedOnSystemSleep = nil, lockAfterTimeInterval = nil)
    options = []
    if isLockedOnSystemSleep
      options << "-l"
    end
    if lockAfterTimeInterval
      options << "-u -t #{lockAfterTimeInterval}"
    end
    options = options.join(" ")
    cmd = "#{exe} set-keychain-settings #{options} #{@nameOrPath}"
    system(cmd)
  end
  
  def info()
    cmd = "#{exe} show-keychain-info #{@nameOrPath}"
    system(cmd)
  end
  
  private
  def self.cleanupFilePath(filePath)
    result = filePath.strip().tr('"', '')
    return result
  end
  
  private
  def exe
    return KeyChain.exe
  end
  
  private
  def self.exe
    cmd = 'security'
    if !Tool.isCIServer
      cmd += ' -v'
    end
    return cmd
  end
  
end
