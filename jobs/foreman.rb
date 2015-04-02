# vi: autoindent tabstop=2 shiftwidth=2 expandtab softtabstop=2 filetype=ruby
# foreman scraper for dashing dashboards
#  Aaron Cupp -- acupp@study.com
#
require "net/https"
require "uri"

produri = URI('https://foreman.ue1.prod.study.com/api/v2/dashboard')
stageuri = URI('https://foreman.ue1.stage.study.com/api/v2/dashboard')
#devuri = URI('https://foreman.ue1.stage.study.com/api/v2/dashboard')


SCHEDULER.every '5s' do
  #  Start Prod Block
  Net::HTTP.start(produri.host, produri.port,
    :use_ssl => produri.scheme == 'https',
    :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

    request = Net::HTTP::Get.new produri.request_uri
    request.basic_auth 'wally', 'igetinfoforthings'

    response = http.request request # Net::HTTPRepose object
    
    hosts = JSON.parse(response.body)["total_hosts"]
    warnings = JSON.parse(response.body)["out_of_sync_hosts"]
    errors = JSON.parse(response.body)["bad_hosts"]
    applied = JSON.parse(response.body)["active_hosts_ok"]
    good = JSON.parse(response.body)["good_hosts"]

    if errors > 0 then
      error_value = errors
      error_color = 'red'
    else
      error_value = errors
      error_color = 'green'
    end   #end errors block
    
    if warnings > 0 then
      warning_value = warnings
      warning_color = 'yellow'
    else
      warning_value = warnings
      warning_color = 'green'
    end   #end warnings block

    if applied > 0 then
      applied_value = applied
      applied_color = 'blue'
    else
      applied_value = applied
      applied_color = 'green'
    end   #end applied block
   
    hosts_value = hosts
    hosts_color = 'green'
    good_value = good
    good_color = 'green'

    send_event('foreman-prod-1', {value: hosts_value, color: hosts_color})  # hosts in Good State
    send_event('foreman-prod-2', {value: good_value, color: good_color})  # hosts in Good State
    send_event('foreman-prod-3', {value: applied_value, color: applied_color})  # hosts w/ applied changes
    send_event('foreman-prod-4', {value: warning_value, color: warning_color})  # hosts Out of Sync
    send_event('foreman-prod-5', {value: error_value, color: error_color})  # hosts with Errors
  end   #end Net::HTTP.start block for Prod

  #  Start Stage Block
  Net::HTTP.start(stageuri.host, stageuri.port,
    :use_ssl => stageuri.scheme == 'https',
    :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|

    request = Net::HTTP::Get.new stageuri.request_uri
    request.basic_auth 'wally', 'igetinfoforthings'

    response = http.request request # Net::HTTPRepose object

    hosts = JSON.parse(response.body)["total_hosts"]
    warnings = JSON.parse(response.body)["out_of_sync_hosts"]
    errors = JSON.parse(response.body)["bad_hosts"]
    applied = JSON.parse(response.body)["active_hosts_ok"]
    good = JSON.parse(response.body)["good_hosts"]

    if errors > 0 then
      error_value = errors
      error_color = 'red'
    else
      error_value = errors
      error_color = 'green'
    end   #end errors block

    if warnings > 0 then
      warning_value = warnings
      warning_color = 'yellow'
    else
      warning_value = warnings
      warning_color = 'green'
    end   #end warnings block

    if applied > 0 then
      applied_value = applied
      applied_color = 'blue'
    else
      applied_value = applied
      applied_color = 'green'
    end   #end applied block

    hosts_value = hosts
    hosts_color = 'green'
    good_value = good
    good_color = 'green'

    send_event('foreman-stage-1', {value: hosts_value, color: hosts_color})  # hosts in Good State
    send_event('foreman-stage-2', {value: good_value, color: good_color})  # hosts in Good State
    send_event('foreman-stage-3', {value: applied_value, color: applied_color})  # hosts w/ applied changes
    send_event('foreman-stage-4', {value: warning_value, color: warning_color})  # hosts Out of Sync
    send_event('foreman-stage-5', {value: error_value, color: error_color})  # hosts with Errors
  end   #end Net::HTTP.start block for Stage

#  #  Start Development VPC Block
#  Net::HTTP.start(devuri.host, devuri.port,
#    :use_ssl => devuri.scheme == 'https',
#    :verify_mode => OpenSSL::SSL::VERIFY_NONE) do |http|
#
#    request = Net::HTTP::Get.new devuri.request_uri
#    request.basic_auth 'wally', 'igetinfoforthings'
#
#    response = http.request request # Net::HTTPRepose object
#
#    hosts = JSON.parse(response.body)["total_hosts"]
#    warnings = JSON.parse(response.body)["out_of_sync_hosts"]
#    errors = JSON.parse(response.body)["bad_hosts"]
#    applied = JSON.parse(response.body)["active_hosts_ok"]
#    good = JSON.parse(response.body)["good_hosts"]
#
#    if errors > 0 then
#      error_value = errors
#      error_color = 'red'
#    else
#      error_value = errors
#      error_color = 'green'
#    end   #end errors block
#
#    if warnings > 0 then
#      warning_value = warnings
#      warning_color = 'yellow'
#    else
#      warning_value = warnings
#      warning_color = 'green'
#    end   #end warnings block
#
#    if applied > 0 then
#      applied_value = applied
#      applied_color = 'blue'
#    else
#      applied_value = applied
#      applied_color = 'green'
#    end   #end applied block
#
#    hosts_value = hosts
#    hosts_color = 'green'
#    good_value = good
#    good_color = 'green'
#
#    send_event('foreman-stage-1', {value: hosts_value, color: hosts_color})  # hosts in Good State
#    send_event('foreman-stage-2', {value: good_value, color: good_color})  # hosts in Good State
#    send_event('foreman-stage-3', {value: applied_value, color: applied_color})  # hosts w/ applied changes
#    send_event('foreman-stage-4', {value: warning_value, color: warning_color})  # hosts Out of Sync
#    send_event('foreman-stage-5', {value: error_value, color: error_color})  # hosts with Errors
#  end   #end Net::HTTP.start block for Stage

end  #end scheduler code block


