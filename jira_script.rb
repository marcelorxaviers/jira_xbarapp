#!/usr/bin/env ruby
# frozen_string_literal: true

require 'time'  # Needed for Time.parse
require_relative 'jira_client'

def jira_client
  @jira_client ||= JiraClient.new
end

# link this file into xbar plugins folder
# ln -s PATH/jira_script.rb XBAR_PATH/xbar/plugins/jira-attendance-support-tickets.1m.rb

# Make it executable
# chmod a+x PATH/jira_script.rb

PRIORITIES = {
  '1' => ':arrow_double_up:',
  '2' => ':arrow_up_small:',
  '3' => ':arrow_up_down:',
  '4' => ':arrow_down_small:',
  '5' => ':arrow_double_down:'
}

# This makes the colour pick between: green (#02A61E), orange (#FC8900) or red (#FF0000)
# green is for zero, orange is for between 1 and 3 and red for 4 and on
def pick_hex_colour(tickets_size)
  case tickets_size
  when 0
    '#02A61E'
  when 1..3
    '#FC8900'
  else
    '#FF0000'
  end
end

def time_since(date)
  now = Time.now
  diff = now - Time.parse(date)

  seconds = diff.to_i
  minutes = seconds / 60
  hours = minutes / 60
  days = hours / 24

  if seconds < 60
    "#{seconds} seconds ago"
  elsif minutes < 60
    "#{minutes} minutes ago"
  elsif hours < 24
    "#{hours} hours ago"
  else
    "#{days} days ago"
  end
end

def tickets(queue_ids:)
  queues = queue_ids.map { |id| jira_client.get_queue(servicedesk_id: 1, queue_id: id) }

  queues.reduce([]) do |tickets, queue|
    tickets + queue["values"].map do |ticket|
       {
        id: ticket['id'],
        key: ticket['key'],
        summary: ticket.dig('fields', 'summary'),
        created: ticket.dig('fields', 'created'),
        status: ticket.dig('fields', 'status', 'name'),
        priority: ticket.dig('fields', 'priority', 'id'),
        url: "#{jira_client.domain}/browse/#{ticket['key']}",
        icon: PRIORITIES[ticket.dig('fields', 'priority', 'id')],
        assignee: ticket.dig('fields', 'assignee', 'displayName')
      }
    end
  end
end

begin
  # Scheduler and Workforce respectively
  tickets = tickets(queue_ids: [18, 20])

  puts "#{tickets.length} :ticket: | size=14 color=#{pick_hex_colour(tickets.length)}"
  puts '---'

  if tickets.empty?
    puts 'No :ticket: to solve :tada:'
  else
    tickets.sort_by { |ticket| ticket[:priority] }.each do |ticket|
      assigned_to = ticket[:assignee] ? "Assigned to #{ticket[:assignee]}" : "Unassigned"
      puts "#{ticket[:icon]} #{ticket[:key]} - #{ticket[:summary]} | href=#{ticket[:url]} size=16"
      puts "#{ticket[:status]}. Created #{time_since(ticket[:created])}. #{assigned_to} | size=12"
      puts '---'
    end
  end
rescue StandardError => e
  puts e.message
end
