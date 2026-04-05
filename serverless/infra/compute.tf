resource "null_resource" "function_zip" {
  provisioner "local-exec" {
    command = "cd ../src && zip -r function.zip ."
  }
}

resource "google_storage_bucket_object" "function_source_code" {
  name       = "function.zip"
  source     = "../src/function.zip"
  bucket     = google_storage_bucket.this.name
  depends_on = [null_resource.function_zip]
}

resource "google_cloudfunctions2_function" "this" {
  name     = "sentiment-analysis-function"
  location = "us-east1"

  build_config {
    runtime     = "python39"
    entry_point = "classifier"
    source {
      storage_source {
        bucket = google_storage_bucket.this.name
        object = google_storage_bucket_object.function_source_code.name
      }
    }
  }

  service_config {
    max_instance_count = 1
    available_memory   = "256M"
    timeout_seconds    = 60
  }
}
