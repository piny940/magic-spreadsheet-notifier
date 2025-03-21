require './src/web_driver'
require './src/logger'

# CELL_INDEX = {
#   title: 1,
#   recruit_start_date: 2,
#   recruit_end_date: 2,
#   technologies: 3,
#   link: 4,
#   kind: 5,
#   company: 6,
#   area: 7,
#   reward: 8,
#   schedule1: 9,
#   schedule2: 10,
#   schedule3: 11,
#   comment: 12
# }
CELLS = {
  'company' => '主催',
  'title' => 'イベント名',
  'kind' => '種別',
  'recruit_end_date' => '締め切り',
  'link' => 'リンク',
  'occupation' => '職種',
  'technologies' => '技術スタック',
  'content' => '内容',
  'schedule' => '実施時期',
  'requirements' => '募集要件',
  'reward' => '待遇',
  'test' => '選考フロー'
}.freeze
module MagicSpreadsheet
  ROW_CSS = '.notion-selectable.notion-page-block.notion-collection-item>.notion-table-view-row'.freeze
  def self.list
    logger.info('Start MagicSpreadsheet.list')
    items = []
    driver = WebDriver.driver
    driver.get(ENV.fetch('MAGIC_SPREADSHEET_URL', nil))
    sleep ENV.fetch('MAGIC_SPREADSHEET_WAIT_TIME', 5).to_i

    scroll_to_bottom(driver)

    begin
      rows = driver.find_elements(:css, ROW_CSS)
      rows.each do |row|
        item = {}
        CELLS.each_key do |k|
          idx = CELLS.keys.index(k)
          cell = row.find_element(:css, ".notion-table-view-cell[data-col-index='#{idx + 1}']")
          if k == 'link' && cell.text != ''
            anchors = cell.find_elements(:css, 'a')
            item[k] = anchors[0].attribute('href') unless anchors.empty?
            next
          end
          item[k] = cell.text
        end
        items << item
      end
    ensure
      driver.quit
    end
    logger.info('End MagicSpreadsheet.list')
    items
  end

  def self.scroll_to_bottom(driver)
    logger.info('Start MagicSpreadsheet.scroll_to_bottom')
    prev_count = 0
    loop do
      driver.execute_script('window.scrollTo(0, document.body.scrollHeight);')
      sleep ENV.fetch('MAGIC_SPREADSHEET_WAIT_TIME', 5).to_i
      rows = driver.find_elements(:css, ROW_CSS)
      break if rows.size == prev_count

      prev_count = rows.size
    end
    logger.info('End MagicSpreadsheet.scroll_to_bottom')
  end
end
