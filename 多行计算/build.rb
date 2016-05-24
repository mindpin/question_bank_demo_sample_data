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

def build_one_content_fix_minus(hang, lie, data)
  count = hang/3 + lie/3

  hangs = (0..hang-1).to_a.sample(count)
  lies = (0..lie-1).to_a.sample(count)

  0.upto(count-1) do |i|
    point_hang = hangs[i]
    point_lie = lies[i]
    data[point_hang][point_lie] = -(data[point_hang][point_lie])
  end

  data
end

def build_one_content(hang, lie)
  data = []
  0.upto(hang-1) do |_hang|
    data[_hang] = []
    0.upto(lie-1) do |_lie|
      data[_hang][_lie] = generate_float(3, 6)
    end
  end
  build_one_content_fix_minus(hang, lie, data)
end

def build_one_answer(hang, lie, data)
  # 计算结果
  answer = {}

  # 计算每个横行的和
  0.upto(hang-1) do |_hang|
    arr = []
    0.upto(lie-1) do |_lie|
      arr.push data[_hang][_lie]
    end

    answer["#{_hang},sum"] = arr.inject(0) do |sum, num|
      _sum = BigDecimal.new(num.to_s) + BigDecimal.new(sum.to_s)
      _sum.to_f
    end
  end

  # 计算每个纵列的和
  0.upto(lie-1) do |_lie|
    arr = []
    0.upto(hang-1) do |_hang|
      arr.push data[_hang][_lie]
    end

    answer["sum,#{_lie}"] = arr.inject(0) do |sum, num|
      _sum = BigDecimal.new(num.to_s) + BigDecimal.new(sum.to_s)
      _sum.to_f
    end
  end

  # 计算总和
  arr = []
  0.upto(hang-1) do |_hang|
    0.upto(lie-1) do |_lie|
      arr.push data[_hang][_lie]
    end
  end
  answer["sum"] = arr.inject(0) do |sum, num|
    _sum = BigDecimal.new(num.to_s) + BigDecimal.new(sum.to_s)
    _sum.to_f
  end
  answer
end

def build_one(hang, lie)
  data = build_one_content(hang, lie)
  {
    content: data,
    answer: build_one_answer(hang , lie, data)
  }
end

# 10 行
hang = 10
# 6 列
lie = 6

result = []
1.upto(1) do
  result.push build_one(hang, lie)
end

json_path = File.join(File.expand_path("../", __FILE__), "build.json")
IO.write(json_path, JSON.generate(result))
