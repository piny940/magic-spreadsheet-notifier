require './src/config' # Load first
require './src/firestore'
require './src/magic'
require './src/recruit'


recruits = MagicSpreadsheet.list

firestore = Firestore.client
recruits.each do |recruit|
  firestore.col("spreadsheets/2023-summer/recruits").doc.set(recruit.to_h)
end
firestore.col("spreadsheets/2023-summer/recruits").get.map{ |doc| p doc.data}
