from google.cloud import storage
import base64
import json

def df(event, callback):
  pubsubMessage = event['data']
  buildResource = json.load(base64.b64decode(pubsubMessage))
  print(buildResource)

  repo = buildResource.substitutions.REPO_NAME
  repoName = buildResource.substitutions.REPO_NAME
  branch = buildResource.substitutions.BRANCH_NAME
  status = buildResource.status

  if branch == "master":
    print("Creating badge for {0} on branch {1}".format(repoName, branch))
    filename = "build/myRepo-{0}.svg".format(branch)
    print("Filename will be {0}".format(filename))
    sobj = storage.Client()

    if repo and branch and status == "SUCCESS":
      print("Detected build success!")
      bucket = sobj.get_bucket("tape4nmt-builds-badge")
      blob = bucket.blob("build/success.svg")
      bucket.copy_blob(blob, bucket, filename)
      print("Switched badge to build success")
      blob.make_public()
      print("Badge set to public.")
    if repo and branch and status == "FAILURE":
      print("Detected build failure!")
      bucket = sobj.get_bucket("tape4nmt-builds-badge")
      blob = bucket.blob("build/failure.svg")
      bucket.copy_blob(blob, bucket, filename)
      print("Switched badge to build failure")
      blob.make_public()
      print("Badge set to public.")

  callback()
