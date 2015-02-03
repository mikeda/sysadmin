#!/usr/bin/env ruby

require 'aws-sdk-v1'

AWS.config(
  region: 'ap-northeast-1'
)

ec2 = AWS::EC2.new

require 'pry'
binding.pry
