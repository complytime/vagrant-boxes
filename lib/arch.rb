case RbConfig::CONFIG["target_cpu"]
when "amd64", "x86_64", "x64"
  puts "amd64"
when "386", "i386", "x86"
  puts "i386"
when "arm64", "aarch64"
  puts "arm64"
else
  puts RbConfig::CONFIG["target_cpu"]
end