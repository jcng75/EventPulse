resource "aws_s3_bucket" "processing_bucket" {
  bucket        = var.processing_bucket.name
  region        = var.processing_bucket.region
  force_destroy = var.processing_bucket.force_destroy

  tags = merge({
    Name = var.processing_bucket.name
  }, var.tags)
}

resource "aws_s3_bucket" "quarantine_bucket" {
  bucket        = var.quarantine_bucket.name
  region        = var.quarantine_bucket.region
  force_destroy = var.quarantine_bucket.force_destroy

  tags = merge({
    Name = var.quarantine_bucket.name
  }, var.tags)
}
