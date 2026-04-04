resource "null_resource" "function_zip" {
  provisioner "local-exec" {
    command = "cd ./function && zip -r function.zip ."
  }
}

resource "google_storage_bucket_object" "function_source_code" {
  name       = "function.zip"
  source     = "./function/function.zip"
  bucket     = google_storage_bucket.this.name
  depends_on = [null_resource.function_zip]
}
