import { initConfig } from './config'
import { fetchRecruits } from './magic'
initConfig()

const main = async () => {
  // console.log(await listRecruits())
  // await deleteRecruit(0)
  // console.log(await listRecruits())
  fetchRecruits()
}

main()
