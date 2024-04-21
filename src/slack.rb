require 'slack-ruby-client'
require './src/firestore'
require './src/logger'
require './src/magic'

module SlackNotifier
  def self.broadcast(attachments)
    teams = Firestore.client.collection('slack_teams').get.map(&:data)
    teams.each do |team|
      client = Slack::Web::Client.new(token: team[:access_token])
      channels = get_channles(client)
      channels.each do |channel|
        logger.info("Send to #{team[:name]}.#{channel.name}")
        client.chat_postMessage(
          channel: channel.id,
          attachments: attachments
        )
      end
    end
  end

  def self.get_channles(client)
    channels = []
    cursor = nil
    loop do
      response = client.conversations_list(cursor: cursor, limit: 1000, exclude_archived: true)
      channels += response.channels
      cursor = response.response_metadata.next_cursor
      break if cursor.nil? || cursor == ''
    end
    channels.to_a.filter(&:is_member)
  end
end

def color(data)
  data['kind'] == 'インターン' ? '#439FE0' : '#36A64F'
end

def key_value_pair(label, data)
  return nil if data.nil? || data == ''

  {
    type: 'rich_text',
    elements: [
      {
        type: 'rich_text_section',
        elements: [
          {
            type: 'text',
            text: label.to_s,
            style: {
              bold: true
            }
          },
          {
            type: 'text',
            text: ": #{data}"
          }
        ]
      }
    ]
  }
end

def notify_recruits(actions)
  new_recruits = actions.filter { |a| a[:action] == :create }.map { |action| action[:data] }
  attachments = new_recruits.map do |data|
    {
      color: color(data),
      blocks: [
        {
          type: 'section',
          text: {
            type: 'mrkdwn',
            text: "*#{data['company']}*\n#{data['title']}\n<#{data['link']}|#{data['link']}>"
          }
        },
        *CELLS.except('company', 'title', 'link').map do |k, v|
          key_value_pair(v, data[k])
        end.compact
      ].compact
    }
  end
  SlackNotifier.broadcast(attachments)
end
