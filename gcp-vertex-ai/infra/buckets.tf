resource "google_storage_bucket" "this" {
  name          = "lamphan-classifier-models-gcp-ai-platform"
  location      = "US"
  force_destroy = true

  public_access_prevention = "enforced"
}

resource "google_storage_bucket_object" "sentiment_evaluation_model" {
  name   = "evaluation_data/sentimental_data_evaluation.csv"
  source = "../training/datasets/sentimental_data_evaluation.csv"
  bucket = google_storage_bucket.this.name
}
