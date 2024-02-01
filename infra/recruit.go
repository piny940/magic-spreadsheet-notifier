package infra

import "magic-spreadsheet-notification/domain"

type recruitRepo struct {
	db DB
}

func NewRecruitRepo(db DB) domain.IRecruitRepo {
	return &recruitRepo{db}
}

func (repo *recruitRepo) List() ([]*domain.Recruit, error) {
	recruits := make([]*domain.Recruit, 0)
	table := repo.db.Client.Table("recruits")
	if err := table.Scan().All(&recruits); err != nil {
		return nil, err
	}
	return recruits, nil
}

func (repo *recruitRepo) Create(recruit *domain.Recruit) (*domain.Recruit, error) {
	table := repo.db.Client.Table("recruits")
	if err := table.Put(recruit).Run(); err != nil {
		return nil, err
	}
	return recruit, nil
}
