require 'json'

def generate_float(min_len, max_len)
  len = rand(min_len..max_len)
  strs = []
  1.upto(len) do
    strs.push(rand(0..9))
  end
  strs.push(".")
  strs.push(rand(0..9))
  strs.push(rand(0..9))
  (strs*"").to_f
end

result = []
1.upto(100000) do
  result.push({
    content: generate_float(3,12)
  })
end

json_path = File.join(File.expand_path("../", __FILE__), "build.json")
IO.write(json_path, JSON.generate(result))
