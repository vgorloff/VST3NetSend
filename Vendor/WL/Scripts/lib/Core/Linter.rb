require_relative 'Tool.rb'

class Linter

  def initialize(projectDir)
    @projectDir = projectDir
    @tool = Tool.new()
  end
  
  def lint()
    cmd = "swiftlint lint --quiet --config \"#{@projectDir}/.swiftlint.yml\""
    system(cmd)
  end
  
  def lintFile(file)
    cmd = "swiftlint lint --quiet --config \"#{@projectDir}/.swiftlint.yml\" --path \"#{file}\""
    system(cmd)
  end
  
  def lintFiles(files)
    filesToCheck = files.select { |f| File.extname(f) == ".swift" }
    filesToCheck.each { |f|
      lintFile(f)
    }
  end
  
  def canRunSwiftLint()
    return @tool.canRunActions("swiftlint") && @tool.isCommandExists("swiftlint")
  end
  
  def canRunSwiftFormat()
    return @tool.canRunActions("swiftformat") && @tool.isCommandExists("swiftformat")
  end
  
  def correctWithSwiftLint()
    `swiftlint autocorrect --quiet --config \"#{@projectDir}/.swiftlint.yml\" --path \"#{@projectDir}\"`
  end
 
  def correctWithSwiftFormat()
    cmd = "swiftformat --disable redundantRawValues,strongOutlets "\
      "--allman false --binarygrouping none --commas inline --comments indent --decimalgrouping none --empty void "\
      "--exponentcase lowercase --header ignore --hexgrouping none --hexliteralcase uppercase --ifdef indent --indent 3 --insertlines enabled "\
      "--linebreaks lf --octalgrouping none --patternlet inline --ranges spaced --removelines true --semicolons inline --self remove "\
      "--stripunusedargs unnamed-only --trimwhitespace always --wraparguments disabled --wrapelements disabled \"#{@projectDir}\" "
    `#{cmd}`
  end
end
