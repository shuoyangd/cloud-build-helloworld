# gcloud functions deploy df --runtime nodejs6 --trigger-resource cloud-builds --trigger-event google.pubsub.topic.publish
gcloud functions deploy df --runtime python37 --trigger-resource cloud-builds --trigger-event google.pubsub.topic.publish
