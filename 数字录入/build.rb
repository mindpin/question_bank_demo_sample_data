require 'json'

def generate_number(min_len, max_len)
  len = rand(min_len..max_len)
  strs = []
  1.upto(len) do
    strs.push(rand(0..9))
  end
  (strs*"").to_i
end

result = []
1.upto(100000) do
  result.push({
    content: generate_number(3,13)
  })
end

json_path = File.join(File.expand_path("../", __FILE__), "build.json")
IO.write(json_path, JSON.generate(result))
