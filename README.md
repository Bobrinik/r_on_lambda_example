# Overview
This repository provides an example of how to deploy R code to AWS Lambda.

## Pre-reqs
- Have AWS account and have AWS cli installed and authenticated https://docs.aws.amazon.com/cli/latest/userguide/getting-started-version.html
- Have Docker installed https://docs.docker.com/engine/install/
- Have node installed https://nodejs.org/en/download/package-manager
- Have aws cdk installed `npm i aws-cdk`

## Layout
- `my_r_app`: contains R code and its runtime and env configs, so that's deployable on lambda.
- `my_r_app_cdk`: contains infrastructure code that would create all necessary resources on AWS to host my_r_app.


## How deployment works?
```bash
cd my_r_app_cdk

# Run cdk list

cdk list

DockerRepository
MyRAppCdkStack
```
It shows two apps to be deployed on AWS. We want to deploy DockerRepository first, since we will be using it to store our R app.

```bash
cdk deploy DockerRepository

...
DockerRepository.RepositoryURI = xxxxx.dkr.ecr.us-east-1.amazonaws.com/r-base-app

```
Copy-paste `xxxxx.dkr.ecr.us-east-1.amazonaws.com/r-base-app` into `my_r_app/.env`.
You `.env` file should look like the following.

```
IMAGE=xxxxx.dkr.ecr.us-east-1.amazonaws.com/r-base-app
```

Now, if you `cd my_r_app` you can do make Docker. Once the image is built you can push it to repo.

Before we push, you need to authenticate with Docker repository.
```bash
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin xxx.dkr.ecr.us-east-1.amazonaws.com

# Now you can push
make push

# Your output will look somehting like this
docker push xx.dkr.ecr.us-east-1.amazonaws.com/r-base:de04a49
The push refers to repository [xx.dkr.ecr.us-east-1.amazonaws.com/r-base]
68e56e5596a0: Layer already exists 
8e8c3c69a0d8: Layer already exists 
feac858170f3: Layer already exists 
1bb17ae8a995: Layer already exists 
0be3828e6371: Layer already exists 
f614c034c39a: Layer already exists 
fed6c82c293a: Layer already exists 
e8e5c6e3f5d5: Layer already exists 
886d53a4f288: Layer already exists 
5e83cbc67e99: Layer already exists 
ae9f122b68e5: Layer already exists 
de04a49: digest: sha256:704f8a63ff66160018d5e7d297025f067de6b6f522e843b25332115d3fca9096 size: 2626
docker push xx.dkr.ecr.us-east-1.amazonaws.com/r-base-app:latest
The push refers to repository [xx.dkr.ecr.us-east-1.amazonaws.com/r-base]
68e56e5596a0: Layer already exists 
8e8c3c69a0d8: Layer already exists 
feac858170f3: Layer already exists 
1bb17ae8a995: Layer already exists 
0be3828e6371: Layer already exists 
f614c034c39a: Layer already exists 
fed6c82c293a: Layer already exists 
e8e5c6e3f5d5: Layer already exists 
886d53a4f288: Layer already exists 
5e83cbc67e99: Layer already exists 
ae9f122b68e5: Layer already exists 
latest: digest: sha256:704f8a63ff66160018d5e7d297025f067de6b6f522e843b25332115d3fca9096 size: 2626
```

By this point, you have all necessary code on the cloud. And you can proceed with the deployment of a lambda function.

```bash
cd my_r_app_cdk

# Once the bellow command finishes
# You have a deployed lambda which hosts your R code
cdk deploy MyRAppCdkStack
```

