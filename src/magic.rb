require './src/web_driver'
require './src/recruit'

CELL_INDEX = {
  title: 1,
  recruit_start_date: 2,
  recruit_end_date: 3,
  technologies: 4,
  link: 5,
  kind: 6,
  company: 7,
  area: 8,
  reward: 9,
  schedule1: 10,
  schedule2: 11,
  schedule3: 12,
  comment: 13,
}
module MagicSpreadsheet
  def self.list
    items = []
    driver = WebDriver.driver
    driver.get(ENV.fetch('MAGIC_SPREADSHEET_URL', nil))
    sleep ENV.fetch('MAGIC_SPREADSHEET_WAIT_TIME', 5).to_i
    begin
      rows = driver.find_elements(:css, '.notion-selectable.notion-page-block.notion-collection-item>.notion-table-view-row')
      rows.each do |row|
        item = {}
        CELL_INDEX.each do |k, v|
          cell = row.find_element(:css, ".notion-table-view-cell[data-col-index='#{v}']")
          if k == :link && cell.text != ''
            item[k] = cell.find_element(:css, 'a').attribute('href')
            next
          end
          item[k] = cell.text
        end
        items << item
      end
    ensure
      driver.quit
    end
    items.map{ |item| Recruit.new(**item) }
  end
end
