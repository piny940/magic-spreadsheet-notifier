import { initConfig } from './config'
import { deleteRecruit, listRecruits } from './dynamo'
initConfig()

const main = async () => {
  console.log(await listRecruits())
  await deleteRecruit(0)
  console.log(await listRecruits())
}

main()
