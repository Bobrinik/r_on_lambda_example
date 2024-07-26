import {CfnOutput, Stack, StackProps} from 'aws-cdk-lib';
import { Construct } from 'constructs';
import { aws_ecr as ecr } from 'aws-cdk-lib';

export class RepositoryStack extends Stack {
    constructor(scope: Construct, id: string, props?: StackProps) {
        super(scope, id, props);

        const repository = new ecr.Repository(this, "MyRepo", {
            repositoryName: "r-base-app"
        });

        new CfnOutput(this, 'RepositoryURI', {
            value: repository.repositoryUri,
            description: 'Docker Repository URI',
            exportName: 'RepositoryURI',
        });
    }
}
