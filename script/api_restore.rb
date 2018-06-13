#!/usr/bin/ruby2.3
require "json"
require 'date'

config = open("config.json") do |io|
	JSON.load(io)
end

# print(JSON.pretty_generate(config));
dd =  DateTime.now
outPath = sprintf("release_%4d%02d%02d_%02d%02d%02d",dd.year,dd.month,dd.day,dd.hour,dd.minute,dd.second)

p "coppy project file from #{config["projectPath"]} to #{outPath}"
`mkdir -p #{outPath}/release`
`mkdir -p #{outPath}/src`
for files in config["projectPath"] do
	`cp -r #{files} #{outPath}/release/`
	`cp -r #{files} #{outPath}/src/`
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
	p jsPath
	p jsOriginal
	p jsTarget
	`java -jar yuicompressor-2.4.8.jar #{jsPath}/#{jsOriginal} -o #{jsPath}/#{jsTarget}  --charset utf-8`
	#	p "rm #{jsTarget}"
	#p "delete original file:: #{jsTarget}/#{jsTarget}"
	`rm #{jsPath}/#{jsOriginal}`
end

for target in config["targetHTML"] do
	p target
	for jsFile in jsFiles do
		str = sprintf("s/%s/%s/",jsFile[:original].split('/').last,jsFile[:target].split('/').last)
		p str
		#out = `sed -e '#{str}' #{outPath}/html/#{config["targetHTML"][0]}`
		`sed -i -e '#{str}' #{outPath}/release/#{target}`
	end
end


`zip -r #{outPath}.zip #{outPath}`

=begin
																																				for instance in config["targetInstance"] do
																																					value = `scp -i \"solutions-op-key-pair.pem\" #{outPath}.zip #{instance}:#{config["targetInstancePath"]}`
																																						p value
																																						end
=end

