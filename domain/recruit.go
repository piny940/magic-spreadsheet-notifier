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
	ID               uint
	Name             string
	RecruitStartDate time.Time
	RecruitEndDate   time.Time
	Technologies     []string
	Link             string
	Kind             RecruitKind
}
