import { initDynamo, listRecruits } from './dynamo'
import { initConfig } from './config'
initConfig()

const main = async () => {
  await listRecruits()
}

main()
