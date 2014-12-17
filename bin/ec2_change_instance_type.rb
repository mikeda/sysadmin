#!/usr/bin/env ruby

require 'aws-sdk-v1'

if ARGV.size != 2
  puts "usage: #{$0} <hostname> <instance_type>"
  exit 1
end
hostname, instance_type = ARGV

config_file = File.join(File.dirname(__FILE__), "../config/aws.yml")
config = YAML.load(File.read(config_file))["default"]

AWS.config(
  region: config['region']
)

ec2 = AWS::EC2.new

instance = ec2.instances.find {|i| i.tags['Name'] == hostname }

instance.stop
sleep 1 until instance.status == :stopped

instance.instance_type = instance_type

instance.start
