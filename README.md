# aws-local-stack
Testing AWS Local Stack.


### How to run the container
`docker-compose up -d`

### Local S3 bucket
How I created a local S3 bucket:
`aws s3 mb s3://shopping-images --endpoint-url=http://localhost:4566 --region=us-east-1`

How to verify if the bucket exists:
`aws s3 ls --endpoint-url=http://localhost:4566`