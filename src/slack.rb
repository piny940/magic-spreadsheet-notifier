require 'slack-ruby-client'

# Slack.configure do |config|
#   config.token = ENV['SLACK_API_TOKEN']
# end

module SlackNotifier
  def self.broadcast(attachments)
    client = Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
    channels = client.conversations_list.channels.to_a
    channels.filter(&:is_member).each do |channel|
      client.chat_postMessage(
        channel: channel.id,
        attachments:
      )
    end
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
