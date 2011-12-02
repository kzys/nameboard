require 'open3'

stdin, stdout, stderr = *Open3.popen3('nkf -s -Z4')
stdin.puts(ARGV.shift)
stdin.close

chars = stdout.gets.chomp.bytes.map do |b|
  if 0x20 <= b and b <= 0x7e # ascii?
    '%c' % b
  else
    '\x%x' % b
  end
end

p chars.length

printf(%Q["%s%s"\n], chars.join(''), ' ' * (40 - chars.length))
p sprintf(%Q["%s%s"\n], chars.join(''), ' ' * (40 - chars.length)).length
