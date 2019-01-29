const { Storage } = require("@google-cloud/storage");

/**
 * Auto-generated from cloud-build-badge. To deploy this cloud function, execute
 * the following command:
 *     gcloud functions deploy christmAIs \
 *         --runtime nodejs6 \
 *         --trigger-resource cloud-builds \
 *         --trigger-event google.pubsub.topic.publish
 *
 * @param {object} event Google Cloud Functions event
 * @param {function} callback callback function for handling events
 */
exports.df = (event, callback) => {
  const pubsubMessage = event.data;
  if (pubsubMessage.data) {
    buildResource = JSON.parse(
      Buffer.from(pubsubMessage.data, "base64").toString()
    );
    repo = buildResource.substitutions.REPO_NAME;
    repoName = buildResource.substitutions.REPO_NAME;
    branch = buildResource.substitutions.BRANCH_NAME;
    status = buildResource.status;

    if (["master"].includes(branch)) {
      console.log("Creating badge for %s on branch %s", repoName, branch);
      const filename = "build/myRepo-" + branch + ".svg";
      console.log("Filename will be %s", filename);
      const storage = new Storage();

      if (repo && branch && status == "SUCCESS") {
        console.log("Detected build success!");
        storage
          .bucket("tape4nmt-builds-badge")
          .file("build/success.svg")
          .copy(storage.bucket("tape4nmt-builds-badge").file(filename));
        console.log("Switched badge to build success");
        storage
          .bucket("tape4nmt-builds-badge")
          .file(filename)
          .makePublic(function(err, apiResponse) {});
        console.log("Badge set to public");
      }
      if (repo && branch && status == "FAILURE") {
        console.log("Detected build failure!");
        storage
          .bucket("tape4nmt-builds-badge")
          .file("build/failure.svg")
          .copy(storage.bucket("tape4nmt-builds-badge").file(filename));
        console.log("Switched badge to build failure");
        storage
          .bucket("tape4nmt-builds-badge")
          .file(filename)
          .makePublic(function(err, apiResponse) {});
        console.log("Badge set to public");
      }
    }
  }
  callback();
};
