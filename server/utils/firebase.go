package utils

import (
	"context"
	"os"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go"
)

func InitFirestore(c context.Context) (*firestore.Client, error) {
	conf := &firebase.Config{ProjectID: os.Getenv("FIREBASE_PROJECT_ID")}
	app, err := firebase.NewApp(c, conf)
	if err != nil {
		return nil, err
	}
	client, err := app.Firestore(c)
	if err != nil {
		return nil, err
	}
	return client, nil
}
