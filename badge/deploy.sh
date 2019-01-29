gcloud functions deploy $BADGE --runtime nodejs6 --trigger-resource cloud-builds --trigger-event google.pubsub.topic.publish
