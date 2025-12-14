# aws-local-stack
Testing AWS Local Stack.

### Docker container
How to run it:
`docker-compose up -d`

### Back-end
How to run it:
`aws-local-stack\code\backend> npm start`

Check out the API endpoints [here](/docs/endpoints.md).

### Local S3 bucket
How I created a local S3 bucket:
`aws s3 mb s3://shopping-images --endpoint-url=http://localhost:4566 --region=us-east-1`

How to verify if the bucket exists:
`aws s3 ls --endpoint-url=http://localhost:4566`