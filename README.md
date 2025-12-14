# aws-local-stack
This repo tests AWS Local Stack :)
Here it's possible to save a image from your computer in a local S3 bucket that emulates AWS S3 service.

🎥 Check out a video demo of the project [here](https://www.youtube.com/watch?v=tR2mZI_unSA).

### Docker container
First, you have to run the Docker container. To run it, go to your project root and type:
`docker-compose up -d`

### Back-end
The back-end API was made with Node.js. It's a very simple service that has a function to upload the image into S3. To run it, type:
`cd code\backend> npm start`

Also, you can check out the API endpoints [here](/docs/endpoints.md).

### Front-end
The front-end interface was made with Flutter. You can run it in your Chrome browser by typing:
`cd code/frontend/mobile_uploader> flutter run -d chrome`

### Local S3 bucket
First, I created a local S3 bucket:
`aws s3 mb s3://shopping-images --endpoint-url=http://localhost:4566 --region=us-east-1`

How to verify if the bucket exists:
`aws s3 ls --endpoint-url=http://localhost:4566`

To get a image from the S3 bucket, run it from your project root:
`aws s3 cp s3://shopping-images/name-of-the-image.PNG . --endpoint-url=http://localhost:4566`

Example: `aws s3 cp s3://shopping-images/0813295a-73f8-4eac-bb47-e0c28bc789b2.jpeg . --endpoint-url=http://localhost:4566`
