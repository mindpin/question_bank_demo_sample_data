require 'json'

json = IO.read("./prepared-business-categories.json")
data = JSON.parse json

arr = []
data.each do |item|
  next if item["jydm"] == "" || item["jydm"] == nil

  arr.push({
    content: item["xmmc"],
    answer:  item["jydm"]
  })
end

IO.write("./build.json", JSON.generate(arr))
