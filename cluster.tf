terraform {}

provider "google" {
  project = "bigeng"
}

data "google_client_config" "default" {}

provider "kubernetes" {
  host = "https://${google_container_cluster.cluster.endpoint}"
  token = data.google_client_config.default.access_token
  cluster_ca_certificate = base64decode(google_container_cluster.cluster.master_auth.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host = "https://${google_container_cluster.cluster.endpoint}"
    token = data.google_client_config.default.access_token
    cluster_ca_certificate = base64decode(google_container_cluster.cluster.master_auth.0.cluster_ca_certificate)
  }
}


variable "gcp_zone" {
  default = "us-west1-b"
}

resource "google_container_cluster" "cluster" {
  name                     = "bigeng"
  location                 = var.gcp_zone
  remove_default_node_pool = true
  initial_node_count       = 1
}

resource "google_container_node_pool" "node_pool" {
  name       = "bigeng"
  location   = var.gcp_zone
  cluster    = google_container_cluster.cluster.name
  node_count = 1

  node_config {
    machine_type = "n1-standard-2"
    preemptible = true
  }

  autoscaling {
    min_node_count = 1
    max_node_count = 3
  }
}

resource "kubernetes_namespace" "namespace" {
  metadata {
    name = "bigeng"
  }
}

resource "helm_release" "vcluster" {
  name = "vcluster"
  chart = "vcluster"
  repository = "https://charts.loft.sh"
  namespace = kubernetes_namespace.namespace.metadata.0.name
}