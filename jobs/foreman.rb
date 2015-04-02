# vi: autoindent tabstop=2 shiftwidth=2 expandtab softtabstop=2 filetype=ruby
# foreman scraper for dashing dashboards
#  Aaron Cupp -- acupp@study.com
#
require "net/https"
require "uri"

uri = URI('https://foreman.ue1.prod.study.com/api/v2/dashboard')


SCHEDULER.every '5s' do
  Net::HTTP.start(uri.host, uri.port,
    :use_ssl => uri.scheme == 'https',
    :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

    request = Net::HTTP::Get.new uri.request_uri
    request.basic_auth 'wally', 'igetinfoforthings'

    response = http.request request # Net::HTTPRepose object
    
    # debug output if good...sometimes
    #puts response
    #puts response.body

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
    end   #end if block

    send_event('foreman', {value: value, color: color})
  end   #end Net::HTTP.start block
end  #end scheduler code block


