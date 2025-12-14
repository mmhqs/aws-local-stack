# aws-local-stack
Testing AWS Local Stack.

### Docker container
How to run it:
`docker-compose up -d`

### Back-end
How to run it:
`cd code\backend> npm start`

Check out the API endpoints [here](/docs/endpoints.md).

### Front-end
How to run Flutter project in Chrome browser:
`cd code/frontend/mobile_uploader> flutter run -d chrome`

### Local S3 bucket
How I created a local S3 bucket:
`aws s3 mb s3://shopping-images --endpoint-url=http://localhost:4566 --region=us-east-1`

How to verify if the bucket exists:
`aws s3 ls --endpoint-url=http://localhost:4566`

To get a image from the S3 bucket, run it from your project root:
`aws s3 cp s3://shopping-images/name-of-the-image.PNG . --endpoint-url=http://localhost:4566`

aws s3 cp s3://shopping-images/0813295a-73f8-4eac-bb47-e0c28bc789b2.jpeg . --endpoint-url=http://localhost:4566