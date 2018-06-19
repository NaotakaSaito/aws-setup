#!/usr/bin/ruby2.3

require 'date'

package = ARGV[0]

if !package then
	package = "release"
end

values = `ls`
files_array = values.split("\n")
backups = []
for file in files_array do
	tmp = file.split(".")
	if tmp.instance_of?(Array) then
		tmp = tmp[0]
	end
	if (backups.include?(tmp) == false) && (tmp.start_with?(package) == true) then
		backups.push(tmp)
	end
end

backupList = []
latest = {}
latest["time"] = Time.at(0)
index = 0
for backup in backups do
	tmp = backup.split("_")
	year = tmp[1][0,4].to_i
	month = tmp[1][4,2].to_i
	day = tmp[1][6,2].to_i
	hour = tmp[2][0,2].to_i
	min = tmp[2][2,2].to_i
	sec = tmp[2][4,2].to_i
	d = Time.local(year, month ,day, hour, min, sec)
	if latest["time"] < d
		latest["time"] = d
		latest["index"] = index
	end
	data = {}
	data["name"] = backup
	data["date"] = d
	backupList.push(data)
	index+=1
end

index = 1
puts ""
puts "please enter file number to be deleted"
puts "[0]\tdelete without latest backup"
for file in backupList do
	puts "[#{index}]\t#{file["name"]}\t#{file["time"]}"
	index += 1
end

puts "[999]\texit"
puts "please enter..."

str = $stdin.gets.chomp!
num = str.to_i
if num == 0 then
	backupList.delete_at(latest["index"])
	for file in backupList do
		cmd = "rm -r #{file["name"]}*"
		puts cmd
		`#{cmd}`
	end
elsif num == 999 then
	puts "exit"
	exit
elsif num > 0 && num <= backupList.length then
	cmd = "rm -r #{backupList[num-1]["name"]}*"
	puts cmd
	`#{cmd}`
else
	puts "input number error"
end

