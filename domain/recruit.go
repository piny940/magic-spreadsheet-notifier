package domain

import "time"

type RecruitKind int

const (
	RecruitKindInternship RecruitKind = iota
	RecruitKindHackathon
	RecruitKindEvent
	RecruitKindJob
	RecruitKindCtf
	RecruitKindWorkshop
)

type Recruit struct {
	ID               uint `dynamo:"id"`
	Name             string
	RecruitStartDate time.Time
	RecruitEndDate   time.Time
	Technologies     []string
	Link             string
	Kind             RecruitKind
	Company          string
	Area             []string
	Reward           string
	Schedule1        string
	Schedule2        string
	Schedule3        string
	Comment          string
}

type IRecruitRepo interface {
	List() ([]*Recruit, error)
	Create(*Recruit) (*Recruit, error)
}
