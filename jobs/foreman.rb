# vi: autoindent tabstop=2 shiftwidth=2 expandtab softtabstop=2 filetype=ruby
# foreman scraper for dashing dashboards
#  Aaron Cupp -- acupp@study.com
#
require "net/https"
require "uri"

hostname="foreman.ue1.prod.study.com"

SCHEDULER.every '4s' do
  http = Net::HTTP.new(hostname,443)
  http.use_ssl = true
  http.ssl_version = :SSLv3
  request = Net::HTTP::Get.new("/api/v2/dashboard")
  request.basic_auth("wally", 'igetinfoforthings')
  response = http.request(request)

  hosts = JSON.parse(response.body)["total_hosts"]
  warnings = JSON.parse(response.body)["out_of_sync_hosts"]
  errors = JSON.parse(response.body)["bad_hosts"]
 
  if errors > 0 then
    value = errors
    color = 'red' + "-blink"
  elsif warnings > 0
    value = warnings
    color = 'yellow'
  else
    value = hosts
    color = 'green'
  end

  send_event('foreman', {
    value: value,
    color: color
  })
end

