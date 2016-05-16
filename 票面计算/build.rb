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

chuan_piao_ben = {}
1.upto(100) do |i|
  chuan_piao_ben[i] = {
    "（一）" => generate_float(3,12),
    "（二）" => generate_float(3,12),
    "（三）" => generate_float(3,12),
    "（四）" => generate_float(3,12),
    "（五）" => generate_float(3,12),
  }
end

IO.write('./chuan_piao_ben.json', JSON.generate(chuan_piao_ben))

arr = []
lines = %w{ （一） （二） （三） （四） （五）}
1.upto(1000) do |i|
  start = rand(1..96)
  _end  = start + rand(4..10)
  _end  = 100 if _end > 100
  line  = lines[rand(0..4)]
  answer = (start.._end).to_a.inject(0) do |sum, page|
    num = chuan_piao_ben[page][line]
    _sum = BigDecimal.new(num.to_s) + BigDecimal.new(sum.to_s)
    _sum.to_f
  end
  arr.push({
    start: start,
    end:   _end,
    line: line,
    answer: answer
  })
end

IO.write('./build.json', JSON.generate(arr))
