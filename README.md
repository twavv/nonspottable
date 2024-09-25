# Connect to the cluster

First, ensure you have accepted the invite from Google Cloud to be an owner of the `bigeng` project.

Install the Google Cloud SDK
  * The official instructions are at https://cloud.google.com/sdk/docs/install
  * If you are on a Mac, you can use Homebrew to install the SDK much easily-er:
    ```
    brew install --cask google-cloud-sdk
    ```

Authenticate with Google Cloud:
```
gcloud auth login
```

Get the cluster credentials:
```
gcloud config set compute/zone us-west1-b
gcloud config set project bigeng
gcloud components install kubectl
gcloud container clusters get-credentials bigeng-cluster
```

If that works, you should be able to run
```
kubectl get nodes
```
and see an output like
```
NAME                              STATUS   ROLES    AGE   VERSION
gke-bigeng-bigeng-630b7c9f-v70m   Ready    <none>   98m   v1.30.3-gke.1969001
```

# Setup vCluster

Follow the instructions at https://vcluster.com/docs/get-started to download the `vcluster` CLI.
 * On a Mac, this is as simple as
  ```
  brew install loft-sh/tap/vcluster-experimental
  ```

# Next steps
See 