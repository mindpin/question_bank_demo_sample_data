require 'rest-client'
require 'json'


citys_str = IO.read("./city.json")
citys = JSON.parse(citys_str)

arr = []
citys.each do |item|
  city = item["city"]

  response = RestClient.get("http://restapi.amap.com/v3/place/text",{
    params: {
      key: "",
      keywords: "",
      types: "小区",
      city: city,
      children: "",
      offset: 50,
      page: 1,
      extensions: "all"
    }
  })
  json = response.to_str
  hash = JSON.parse json
  hash["pois"].each do |poi|
    arr.push({
      id:       poi["id"],
      name:     poi["name"],
      type:     poi["type"],
      typecode: poi["typecode"],
      address:  poi["address"],
      location: poi["location"],
      pcode:    poi["pcode"],
      pname:    poi["pname"],
      citycode: poi["citycode"],
      cityname: poi["cityname"],
      adcode:   poi["adcode"],
      adname:   poi["adname"],
    })
  end

end


IO.write("./locations.json", JSON.generate(arr))
