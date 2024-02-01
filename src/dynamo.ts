import { DynamoDBClient, ScanCommand } from '@aws-sdk/client-dynamodb'
import { Recruit } from './types'

const client = new DynamoDBClient({ region: 'ap-southeast-2' })

const marshal = (item: any) => {
  const result: any = {}

  for (const key of Object.keys(item)) {
    if (typeof item[key] === 'number') result[key] = { N: item[key].toString() }
    else if (typeof item[key] === 'string') result[key] = { S: item[key] }
    else if (typeof item[key] === 'boolean') result[key] = { BOOL: item[key] }
    else if (Array.isArray(item[key]))
      result[key] = { L: item[key].map(marshal) }
    else if (item[key] instanceof Date)
      result[key] = { S: item[key].toISOString() }
    else if (item[key] === null) result[key] = { NULL: true }
    else {
      result[key] = { M: marshal(item[key]) }
    }
  }
  return result
}
const unmarshal = <T = any>(item: any): T => {
  let result: any = {}

  if (Array.isArray(item)) return item.map(unmarshal) as T
  for (const key of Object.keys(item)) {
    if (key === 'N') result = Number(item[key])
    else if (key === 'M') result = unmarshal(item[key])
    else if (key === 'L') result = item[key].map(unmarshal)
    else if (key === 'NULL') result = null
    else if (['S', 'BOOL', 'SS', 'NS', 'BS'].includes(key)) result = item[key]
    else {
      result[key] = unmarshal(item[key])
    }
  }
  return result as T
}

export const listRecruits = async () => {
  const command = new ScanCommand({ TableName: 'recruits' })
  const response = await client.send(command)
  if (!response.Items) return []
  return unmarshal<Recruit[]>(response.Items)
}
