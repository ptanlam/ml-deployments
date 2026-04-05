resource "google_storage_bucket" "this" {
  name          = "lamphan-classifier-models"
  location      = "US"
  force_destroy = true

  public_access_prevention = "enforced"
}

resource "google_storage_bucket_object" "decision_tree_model" {
  name   = "decision_tree_clf/model.pkl"
  source = "../training/models/decision_tree_clf/model.pkl"
  bucket = google_storage_bucket.this.name
}

resource "google_storage_bucket_object" "linear_svc_model" {
  name   = "linear_svc_clf/model.pkl"
  source = "../training/models/linear_svc_clf/model.pkl"
  bucket = google_storage_bucket.this.name
}

resource "google_storage_bucket_object" "logistic_regression_model" {
  name   = "logistic_regression_clf/model.pkl"
  source = "../training/models/logistic_regression_clf/model.pkl"
  bucket = google_storage_bucket.this.name
}
