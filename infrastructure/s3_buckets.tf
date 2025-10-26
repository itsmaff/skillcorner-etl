###############################################################################
# s3_buckets.tf
###############################################################################

resource "aws_s3_bucket" "raw" {
  bucket = "skillcorner-etl-raw"
  tags = {
    Layer   = "Raw"
    Purpose = "Landing zone for ingested source data"
  }
}

resource "aws_s3_bucket" "bronze" {
  bucket = "skillcorner-etl-bronze"
  tags = {
    Layer   = "Bronze"
    Purpose = "Normalized base tables from raw sources"
  }
}

resource "aws_s3_bucket" "silver" {
  bucket = "skillcorner-etl-silver"
  tags = {
    Layer   = "Silver"
    Purpose = "Cleaned and conformed datasets for analytics"
  }
}

resource "aws_s3_bucket" "gold" {
  bucket = "skillcorner-etl-gold"
  tags = {
    Layer   = "Gold"
    Purpose = "Aggregated analytical tables for downstream usage"
  }
}

###############################################################################
# Outputs
###############################################################################

output "bucket_names" {
  description = "S3 bucket names representing the Raw, Bronze, Silver, and Gold layers"
  value = [
    aws_s3_bucket.raw.bucket,
    aws_s3_bucket.bronze.bucket,
    aws_s3_bucket.silver.bucket,
    aws_s3_bucket.gold.bucket
  ]
}