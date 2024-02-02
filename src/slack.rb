require 'slack-ruby-client'

# Slack.configure do |config|
#   config.token = ENV['SLACK_API_TOKEN']
# end

module SlackNotifier
  def self.broadcast(message)
    client = Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
    channels = client.conversations_list.channels.to_a
    channels.filter(&:is_member).each do |channel|
      client.chat_postMessage(
        channel: channel.id,
        text: message
      )
    end
  end
end
