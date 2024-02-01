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
	ID               uint      `gorm:"primary_key"`
	Name             string    `gorm:"not null; type:varchar(100)"`
	RecruitStartDate time.Time `gorm:"type:timestamp"`
	RecruitEndDate   time.Time `gorm:"type:timestamp"`
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

type RecruitRepo interface {
	List() ([]Recruit, error)
	Create(*Recruit) error
}
