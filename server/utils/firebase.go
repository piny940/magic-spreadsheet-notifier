package utils

import (
	"context"
	"os"

	"cloud.google.com/go/firestore"
	firebase "firebase.google.com/go"
)

func InitFirebase() {
	cred := os.Getenv("FIREBASE_JSON")
	filename := "/tmp/firebase.json"
	f, err := os.Create(filename)
	if err != nil {
		panic(err)
	}
	defer f.Close()
	os.Setenv("GOOGLE_APPLICATION_CREDENTIALS", filename)
	_, err = f.WriteString(cred)
	if err != nil {
		panic(err)
	}
}

func GetFirestore(c context.Context) (*firestore.Client, error) {
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
