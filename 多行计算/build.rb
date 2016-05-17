require 'json'
require 'bigdecimal'

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

def build_one_content_fix_minus(x, y, data)
  count = x/3 + y/3

  xs = (0..x-1).to_a.sample(count)
  ys = (0..y-1).to_a.sample(count)

  0.upto(count-1) do |i|
    point_x = xs[i]
    point_y = ys[i]
    data[point_x][point_y] = -(data[point_x][point_y])
  end

  data
end

def build_one_content(x, y)
  data = []
  0.upto(x-1) do |_x|
    data[_x] = []
    0.upto(y-1) do |_y|
      data[_x][_y] = generate_float(3, 6)
    end
  end
  build_one_content_fix_minus(x, y, data)
end

def build_one_answer(x, y, data)
  # 计算结果
  answer = {}

  # 计算每个横行的和
  0.upto(y-1) do |_y|
    arr = []
    0.upto(x-1) do |_x|
      arr.push data[_x][_y]
    end

    answer["sum,#{_y}"] = arr.inject(0) do |sum, num|
      _sum = BigDecimal.new(num.to_s) + BigDecimal.new(sum.to_s)
      _sum.to_f
    end
  end

  # 计算每个纵列的和
  0.upto(x-1) do |_x|
    arr = []
    0.upto(y-1) do |_y|
      arr.push data[_x][_y]
    end

    answer["#{_x},sum"] = arr.inject(0) do |sum, num|
      _sum = BigDecimal.new(num.to_s) + BigDecimal.new(sum.to_s)
      _sum.to_f
    end
  end

  # 计算总和
  arr = []
  0.upto(x-1) do |_x|
    0.upto(y-1) do |_y|
      arr.push data[_x][_y]
    end
  end
  answer["sum"] = arr.inject(0) do |sum, num|
    _sum = BigDecimal.new(num.to_s) + BigDecimal.new(sum.to_s)
    _sum.to_f
  end
  answer
end

def build_one(x, y)
  data = build_one_content(x, y)
  {
    content: data,
    answer: build_one_answer(x,y, data)
  }
end

# 6 纵列
x = 6
# 10 行
y = 10

result = []
1.upto(1) do
  result.push build_one(x, y)
end

json_path = File.join(File.expand_path("../", __FILE__), "build.json")
IO.write(json_path, JSON.generate(result))
