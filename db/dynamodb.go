package db

import (
	"context"
	"fmt"

	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/guregu/dynamo"
)

func Init(ctx context.Context) {
	sess := session.Must(session.NewSession())
	db := dynamo.New(sess)
	fmt.Println(db)
}
