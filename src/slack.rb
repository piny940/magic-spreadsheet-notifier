require 'slack-ruby-client'
require './src/firestore'
require './src/logger'

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
          attachments:
        )
      end
    end
  end

  def self.get_channles(client)
    channels = []
    cursor = nil
    loop do
      response = client.conversations_list(cursor:, limit: 1000, exclude_archived: true)
      channels += response.channels
      cursor = response.response_metadata.next_cursor
      if cursor.nil? || cursor == ''
        break
      end
    end
    channels.to_a.filter(&:is_member)
  end
end

def color(data)
  data['kind'] == 'インターン' ? '#439FE0' : '#36A64F'
end

def key_value_pair(label, data)
  if data.nil? || data == ''
    return nil
  end
  {
    type: 'rich_text',
    elements: [
      {
        type: 'rich_text_section',
        elements: [
          {
            type: 'text',
            text: "#{label}",
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
  new_recruits = actions.filter{|a| a[:action] == :create}.map{|action| action[:data]}
  attachments = new_recruits.map{ |data|
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
        key_value_pair('種類', data['kind']),
        key_value_pair('募集開始', data['recruit_start_date']),
        key_value_pair('締め切り', data['recruit_end_date']),
        key_value_pair('技術', data['technologies'].gsub("\n", '・')),
        key_value_pair('場所', data['area'].gsub("\n", '・')),
        key_value_pair('待遇', data['reward']),
        key_value_pair('期間1', data['schedule1']),
        key_value_pair('期間2', data['schedule2']),
        key_value_pair('期間3', data['schedule3']),
        key_value_pair('コメント', data['comment'])
      ].compact
    }
  }
  SlackNotifier.broadcast(attachments)
end
