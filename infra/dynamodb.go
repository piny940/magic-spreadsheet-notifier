package infra

import (
	"context"

	"github.com/aws/aws-sdk-go/aws"
	"github.com/aws/aws-sdk-go/aws/session"
	"github.com/guregu/dynamo"
)

type DB struct {
	Client *dynamo.DB
}

var db *DB

func Init(ctx context.Context) {
	sess := session.Must(session.NewSession())
	dynamoDb := dynamo.New(sess, &aws.Config{Region: aws.String("ap-southeast-2")})
	db = &DB{Client: dynamoDb}
}

func GetDB() *DB {
	return db
}
