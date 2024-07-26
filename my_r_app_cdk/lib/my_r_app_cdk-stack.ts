import {CfnOutput, Duration, Stack, StackProps} from 'aws-cdk-lib';
import { Construct } from 'constructs';
import {EcrImageCode, Handler, Runtime} from "aws-cdk-lib/aws-lambda";
import { aws_ecr as ecr } from 'aws-cdk-lib';
import * as lambda from 'aws-cdk-lib/aws-lambda';

export class MyRAppCdkStack extends Stack {
  constructor(scope: Construct, id: string, props?: StackProps) {
    super(scope, id, props);

    const repository = ecr.Repository.fromRepositoryName(this, "MyRepo", "r-base-app");

    new lambda.Function(this, 'lambdaContainerFunction', {
      functionName: "run-r-script",
      description: "Sample Lambda Container Function Executing R",
      code:  new EcrImageCode(repository, {
        tagOrDigest: "latest"
      }),
      handler: Handler.FROM_IMAGE,
      runtime: Runtime.FROM_IMAGE,
      memorySize: 1000,
      timeout: Duration.seconds(10)
    });
  }
}
