require './src/config' # Load first
require './src/firestore'
require './src/magic'
require './src/recruit'

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
current = firestore.col("spreadsheets/2023-summer/recruits").get.to_a

actions = diff(current, desired)
firestore.batch do |b|
  actions.each do |action|
    if action[:action] == :create
      # batchだとcol.doc.setが使えない?
      firestore.col("spreadsheets/2023-summer/recruits").doc.set(action[:data])
    else
      b.delete("spreadsheets/2023-summer/recruits/#{action[:data]}")
    end
  end
end
