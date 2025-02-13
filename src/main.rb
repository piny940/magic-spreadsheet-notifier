require './src/config' # Load first
require './src/logger'
require './src/firestore'
require './src/magic'
require './src/slack'

COLLECTION_PATH = ENV.fetch('FIRESTORE_COLLECTION_PATH', nil)

def diff(current, desired)
  actions = []
  desired.each do |recruit|
    key = match_key(recruit)
    found = current.find { |r| key <= r.fields.transform_keys(&:to_s) }
    if found.nil?
      actions << { data: recruit.to_h, action: :create }
    else
      current.delete(found)
    end
  end
  current.each do |recruit|
    actions << { data: recruit.document_id, action: :delete }
  end
  actions
end

MATCH_KEYS = %w[title kind company technologies].freeze
def match_key(recruit)
  recruit.slice(*MATCH_KEYS)
end

desired = MagicSpreadsheet.list
desired = desired.reject { |r| r['title'].nil? || r['title'].empty? || r['company'].nil? || r['company'].empty? }

firestore = Firestore.client
current = firestore.col(COLLECTION_PATH).get.to_a

actions = diff(current, desired)
logger.info("Actions: #{actions}")

# Firestoreに書き込む
logger.info('Start Firestore.batch')
firestore.batch do |b|
  actions.each do |action|
    if action[:action] == :create
      # batchだとcol.doc.setが使えない?
      firestore.col(COLLECTION_PATH).doc.set(action[:data])
    else
      b.delete("#{COLLECTION_PATH}/#{action[:data]}")
    end
  end
end

# Slackに通知する
new_recruits = actions.filter { |a| a[:action] == :create }.map { |action| action[:data] }
notify_recruits(actions) if new_recruits.length.positive?
