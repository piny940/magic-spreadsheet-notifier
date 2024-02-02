import { Builder, By } from 'selenium-webdriver'

const browser = process.env.BROWSER || 'chrome'
export const fetchRecruits = async () => {
  console.log('hoge')
  const driver = new Builder().forBrowser(browser).build()
  await driver.get('https://www.google.com')
  const el = await driver.findElement(By.className('L3eUgb'))
  console.log(el)
  await driver.quit()
}
