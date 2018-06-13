#!/usr/bin/ruby2.3
require "json"
require 'date'

targetZip = ARGV[0]
targetPath = targetZip.split('.')[0]
workPath = targetPath.split("/");
workPath.pop()
workPath = workPath.join("/")

p targetPath
p targetZip
p workPath

cmd = "unzip #{targetZip} -d #{workPath}"
puts cmd
`#{cmd}`
puts ""
Dir.chdir("/home/ubuntu/release")

values = `pwd`
puts values
cmd = "sudo forever --uid 0 stopall"
puts cmd
values = `#{cmd}`
puts values
puts ""

cmd = "cp -r #{targetPath}/* /home/ubuntu/release"
puts cmd
values = `#{cmd}`
puts values
puts ""

cmd = "sudo forever --uid 0 start app.js"
puts cmd
values = `#{cmd}`
puts values
puts ""


cmd = "rm -r #{targetPath}"
puts cmd
values = `#{cmd}`
puts values

