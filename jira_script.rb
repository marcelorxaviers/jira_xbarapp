#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'jira_client'

# link this file into xbar plugins folder
# ln -s PATH/jira_script.rb XBAR_PATH/xbar/plugins/jira-attendance-support-tickets.1m.rb

# Make it executable
# chmod a+x PATH/jira_script.rb

# This makes the colour pick between: green (#02A61E), orange (#FC8900) or red (#FF0000)
# green is for zero, orange is for between 1 and 5 and red for 6 and on
def pick_hex_colour(tickets_size)
  case tickets_size
  when 0
    '#02A61E'
  when 1..5
    '#FC8900'
  else
    '#FF0000'
  end
end

queue = JiraClient.new.get_queue(servicedesk_id: 1, queue_id: 18)

puts "#{queue['size']} :ticket: | size=16 color=#{pick_hex_colour(queue['size'])}"
puts '---'
puts 'No :ticket: to solve :tada:' if queue['size'].zero?

queue['values'].each do |ticket|
  if ticket.dig('fields', 'status', 'name').end_with?('support')
    url = "https://jobandtalent.atlassian.net/browse/#{ticket['key']}"
    puts "#{ticket['key']} - #{ticket.dig('fields', 'summary')} | href=#{url} size=12"
  else
    puts "#{ticket['key']} is #{ticket.dig('fields', 'status', 'name')}"
  end
  puts '---'
end
