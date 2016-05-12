origin_data_items = %w{
  kc-cont-accounting-basic
  kc-cont-company-debt
  kc-cont-personal-debt
  kc-cont-risk-mgmt
  kc-cont-bank-basic
  kc-cont-operator-practice
  kc-cont-personal-finance
}

origin_data_items.each do |item|
  item_path = File.expand_path("../#{item}", __FILE__)
  if !File.exists?(item_path)
    `git clone https://github.com/pimgeek/#{item}.git`
  else
    Dir.chdir(item_path) do
      `git pull origin`
    end
  end
end

require 'fileutils'
require 'json'

base_path  = File.expand_path("../", __FILE__)
build_path = File.join(base_path, "build")
if File.exists?(build_path)
  FileUtils.rm_rf(build_path)
end

GSUB_PARAMS = [
  [ /^#.*/,   ""],
  [ /<br \/>/, "\n"],
  [ /<\/?p>/,  "\n"],
  [ /<.*>/, ""],
  [ /\s*&nbsp;\s*/, ""],
  [ /\s*&quot;\s*/, "\""],
  [ /\s*&ldquo;\s*/, "\""],
  [ /\s*&rdquo;\s*/, "\""],
  [ /\s*&rsquo;\s*/, "\'"],
  [ /\s*&lt;\s*/, "<"],
  [ /\s*&gt;\s*/, ">"],
  [ /^\s*/, ""],
  [ /\s*$/, ""],
  [ /\!\[\]\(.*\)/, ""],
  [ /\r\n/,   "\n"],
  [ /\A\n*/,    ""],
]

def process_content(content)
  GSUB_PARAMS.each do |param|
    content = content.gsub(param[0], param[1])
  end
  line_size = 40
  content = content.gsub(/^.{#{line_size},}$/) do |line|
    strs = []
    strs.push line[0..line_size-1]
    strs.push line[line_size..-1]

    last_str = strs.last
    while strs.last.size > line_size
      strs.pop
      strs.push last_str[0..line_size-1]
      strs.push last_str[line_size..-1]
      last_str = strs.last
    end
    strs.join("\n")
  end
  content = content.gsub(/\n{1,}/, "\n")
  content
end

result = []
Dir[File.join(base_path, "**/*.md")].each do |path|
  name = path.gsub(base_path, "").gsub(/^\//,"")

  content = IO.read path
  content = process_content(content)

  # build md
  path = File.join(build_path, name)
  FileUtils.mkdir_p(File.dirname(path))
  IO.write(path, content)

  result.push({
    name: name,
    content: content
  })

end

# build json
json = JSON.generate result
IO.write(File.join(build_path, "build.json"), json)
