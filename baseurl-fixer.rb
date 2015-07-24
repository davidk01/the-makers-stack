#!/usr/bin/env ruby
data = 'appTitle=Stash&baseUrl=http%3A%2F%2Flocalhost%3A7990%2Fstash&locale=en_US&sshEnabled=on&sshAccessKeysEnabled=on&sshPort=7999&sshBaseUrl=&submit=Save'
atl_token = `curl -c cookies -b cookies -v -k -u admin:admin -XPOST --data "#{data}" http://localhost:7990/stash/admin/server-settings`.match(/atl_token"\s+value="(.+?)"/)
while atl_token.nil? || $?.exitstatus > 0
  sleep 20
  atl_token = `curl -c cookies -b cookies -v -k -u admin:admin -XPOST --data "#{data}" http://localhost:7990/stash/admin/server-settings`.match(/atl_token"\s+value="(.+?)"/)
end
atl_token = atl_token[1]
data = data + "&atl_token=#{atl_token}"
`curl -c cookies -b cookies -v -k -u admin:admin -XPOST --data "#{data}" http://localhost:7990/stash/admin/server-settings`
