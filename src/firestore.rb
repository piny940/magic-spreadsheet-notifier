require 'google/cloud/firestore'

File.open('tmp/firebase.json', 'w') do |f|
  f.write(ENV.fetch('FIREBASE_JSON', nil))
  ENV['GOOGLE_APPLICATION_CREDENTIALS'] = 'tmp/firebase.json'
end

module Firestore
  def self.client
    firestore = Google::Cloud::Firestore.new(project_id: ENV.fetch('FIREBASE_PROJECT_ID', nil))
  end
end
