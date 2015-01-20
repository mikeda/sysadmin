#!/usr/bin/env ruby

require 'aws-sdk-v1'

if ARGV.size != 3
  puts "usage: #{$0} <hostname> <role> <instance_type>"
  exit 1
end
hostname, role, instance_type = ARGV

config_file = File.join(File.dirname(__FILE__), "../config/aws.yml")
config = YAML.load(File.read(config_file))[role]
unless config
  puts "'#{role}' config is not found"
  exit 1
end

AWS.config(
  region: config['region']
)

ec2 = AWS::EC2.new

### インスタンス作成
instance = ec2.instances.create(
  image_id:        config['image_id'],
  instance_type:   instance_type,
  key_name:        config['key_name'],
  subnet:          config['subnet_id'],
  user_data:       File.read(config['user_data_script']),
  security_group_ids: config['security_group_ids'],
  iam_instance_profile: config['iam_instance_profile'],
  block_device_mappings: [
    {
      device_name: '/dev/xvda',
      ebs: { volume_size: config['ebs_size'].to_i }
    }
  ]
)

while instance.status != :running
  puts "Launching instance #{instance.id}, status: #{instance.status}"
  sleep 5
end

### EIPのAllocateとAssociate
elastic_ip = ec2.elastic_ips.create(vpc: config['vpc_id'])
# なんかエラーになるのでちょっとsleep
sleep 5

instance.associate_elastic_ip(elastic_ip)
puts "associated EIP : #{elastic_ip.ip_address}"

### タグ設定
root_volume = instance.attachments['/dev/xvda'].volume

ec2.tags.create(instance,    'Name', value: hostname)
ec2.tags.create(root_volume, 'Name', value: "#{hostname}_root")

### Route53にレコード追加
r53 = AWS::Route53.new
hosted_zone = r53.hosted_zones[config['hosted_zone_id']]
fqdn = hostname + '.' + hosted_zone.name
hosted_zone.rrsets.create(
  fqdn,
  'CNAME',
  ttl: 300,
  resource_records: [
    { value: instance.public_dns_name}
  ]
)
puts "create DNS record : #{fqdn}"
