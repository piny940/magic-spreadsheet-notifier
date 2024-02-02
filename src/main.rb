require './src/config' # Load first
require './src/firestore'
require './src/magic'
require './src/recruit'
require './src/slack'

COLLECTION_PATH = ENV.fetch('FIRESTORE_COLLECTION_PATH', nil)

def diff(current, desired)
  actions = []
  desired.each do |recruit|
    key = match_key(recruit)
    found = current.find{ |r| key <= r.data }
    if found.nil?
      actions << { data: recruit.to_h, action: :create }
    else
      current.delete(found)
    end
  end
  current.each do |recruit|
    actions << { data: recruit.document_id, action: :delete }
  end
  return actions
end

def match_key(recruit)
  {
    title: recruit.title,
    kind: recruit.kind,
    company: recruit.company,
    technologies: recruit.technologies
  }
end

desired = MagicSpreadsheet.list

firestore = Firestore.client
current = firestore.col(COLLECTION_PATH).get.to_a

actions = diff(current, desired)
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

new_recruits = actions.filter{|a| a[:action] == :create}.map{|action| action[:data]}
if new_recruits.length > 0
  notify_recruits(actions)
end
