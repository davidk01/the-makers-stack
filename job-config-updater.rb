#!/usr/bin/env ruby
# Add ssh keys
`ssh -o StrictHostKeyChecking=no git@localhost -p 7999`
# Extract job configuration URLs
job_urls = `curl localhost:8080/api/xml`.scan(
  %r{http://localhost:8080/job.+?<}).map {|url| url.sub('<', 'config.xml')}
# Update and upload new configuration
job_urls.each do |url|
  # Download and modify configuration to point to ssh:// instead of https://
  config = `curl #{url}`
  updated_config = config.gsub(
    'http://admin:admin@localhost:7990/stash/scm', 'ssh://git@localhost:7999').gsub(
    'curl -s', 'curl -k -s')
  open('updated_config.xml', 'w') {|f| f.write(updated_config)}
  # Upload updated configuration
  `curl -XPOST #{url} --data-binary @updated_config.xml`
end
