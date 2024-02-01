import {
  DeleteItemCommand,
  DynamoDBClient,
  PutItemCommand,
  ScanCommand,
} from '@aws-sdk/client-dynamodb'
import { Recruit } from './types'

const client = new DynamoDBClient({ region: 'ap-southeast-2' })

const marshal = (item: any) => {
  const marshalRec = (item: any): any => {
    const result: any = {}

    if (typeof item === 'number') return { N: item.toString() }
    if (typeof item === 'string') return { S: item }
    if (typeof item === 'boolean') return { BOOL: item }
    if (Array.isArray(item)) return { L: item.map(marshalRec) }
    if (item instanceof Date) return { S: item.toISOString() }
    if (item === null) return { NULL: true }
    for (const key of Object.keys(item)) {
      result[key] = { M: marshalRec(item[key]) }
    }
    return result
  }
  const result: any = {}
  for (const key of Object.keys(item)) {
    result[key] = marshalRec(item[key])
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
export const putRecruit = async (recruit: Recruit) => {
  const command = new PutItemCommand({
    TableName: 'recruits',
    Item: marshal(recruit),
  })
  const response = await client.send(command)
  return response
}
export const deleteRecruit = async (id: number) => {
  const command = new DeleteItemCommand({
    TableName: 'recruits',
    Key: { id: { N: id.toString() } },
  })
  const response = await client.send(command)
  return response
}
