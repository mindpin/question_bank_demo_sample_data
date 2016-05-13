require 'json'


locations_str = IO.read('./locations.json')


locations = JSON.parse(locations_str)

size = locations.size

arr = []
1.step(size, 25) do |i|
  location = locations[i]

  if location["pname"] == location["cityname"]
    p_city = location["cityname"]
  else
    p_city = "#{location["pname"]}#{location["cityname"]}"
  end
  content = "#{p_city}#{location["adname"]}#{location["address"]}#{location["name"]}"
  arr.push({
    content: content
  })
end

IO.write("./build.json", JSON.generate(arr))
