export type Recruit = {
  id: number
  name: string
  recruitStartDate: Date
  recruitEndDate: Date
  technologies: string[]
  link: string
  kind: RecruitKind
  company: string
  area: string[]
  reward: string
  schedule1: string
  schedule2: string
  schedule3: string
  comment: string
}
export enum RecruitKind {
  INTERNSHIP = 'INTERNSHIP',
  HACKATHON = 'HACKATHON',
  EVENT = 'EVENT',
  JOB = 'JOB',
  CTF = 'CTF',
  WORKSHOP = 'WORKSHOP'
}