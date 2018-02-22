#!/usr/bin/ruby2.3
require "json"
require 'date'

config = open("config.json") do |io|
	JSON.load(io)
end

# print(JSON.pretty_generate(config));
dd =  DateTime.now
outPath = sprintf("release_%4d%02d%02d_%02d%02d%02d",dd.year,dd.month,dd.day,dd.hour,dd.minute,dd.second)

puts "coppy project file from #{config["projectPath"]} to #{outPath}"
`mkdir -p #{outPath}/release`
`mkdir -p #{outPath}/src`
for files in config["projectPath"] do
	`cp -r #{files["src"]} #{outPath}/release/#{files["dst"]}`
	`cp -r #{files["src"]} #{outPath}/src/#{files["dst"]}`
end

jsFiles=[]
for row in config["targetJS"] do
	p row
	row_split = row.split("/")
	#p row_split
	#p row_split[0..-2]
	#jsFileOriginal = outPath+"/release/"+row_split[0,row_split.length-2].join('/')+"/"+row_split.last
	#jsPath = outPath+"/release/"+row_split[0,row_split.length-2].join('/')
	jsPath = outPath+"/release/"+row_split[0..-2].join('/')
	libPath = row_split[0..-2].join('/')
	jsOriginal = row_split.last
	jsTarget = row_split.last.gsub(/\.js/,'.min.js')
	jsFiles.push({
		"original": libPath+'/'+jsOriginal,
		"target": libPath+'/'+jsTarget
	})
	`java -jar yuicompressor-2.4.8.jar #{jsPath}/#{jsOriginal} -o #{jsPath}/#{jsTarget}  --charset utf-8`
	#	p "rm #{jsTarget}"
	#p "delete original file:: #{jsTarget}/#{jsTarget}"
	`rm #{jsPath}/#{jsOriginal}`
end

puts ""
puts ""
for target in config["targetHTML"] do
	puts "change HTML file for min.js :: #{target}"
	for jsFile in jsFiles do
		str = sprintf("s/%s/%s/",jsFile[:original].split('/').last,jsFile[:target].split('/').last)
		#out = `sed -e '#{str}' #{outPath}/html/#{config["targetHTML"][0]}`
		`sed -i -e '#{str}' #{outPath}/release/#{target}`
	end
end


puts ""
puts ""
puts "generating zip file::  #{outPath}"
`zip -r #{outPath}.zip #{outPath}`

puts ""
puts ""
for instance in config["targetInstance"] do
puts "sending zip file to #{instance["dns"]}"
	values = `scp -i \"solutions-op-key-pair.pem\" #{outPath}.zip #{instance["dns"]}:#{config["targetInstancePath"]}`
	puts "send run command to deploy data in server"
	values = `scp -i \"solutions-op-key-pair.pem\" #{outPath}.zip #{instance["dns"]}:#{config["targetInstancePath"]}`
	puts "success to send"
	puts ""
	puts "deploy files to test site::"
	values = `aws ssm send-command --document-name "AWS-RunShellScript" --comment "deploy html" --instance-ids #{instance["id"]} --parameters commands="/home/ubuntu/html_deploy.rb #{config["targetInstancePath"]}/#{outPath}.zip release" --region ap-northeast-1 --output json`
	puts values
	result = JSON.parse(values)
	puts ""
	puts "wait sevral seconds..."
	sleep 5
	puts ""
	values = `aws ssm list-command-invocations --command-id "#{result["Command"]["CommandId"]}" --details`
	result = JSON.parse(values)
	puts ""
	puts "result of deploy files::"
	puts values
	for commandInvocations in result["CommandInvocations"] do
		for commandPlugins in commandInvocations["CommandPlugins"] do
			puts commandPlugins["Output"]
		end
	end
end


