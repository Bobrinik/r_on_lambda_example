#!/usr/bin/env node
import * as cdk from 'aws-cdk-lib';
import { MyRAppCdkStack } from '../lib/my_r_app_cdk-stack';
import {RepositoryStack} from "../lib/repository_stack";

const app = new cdk.App();
new RepositoryStack(app, "DockerRepository");
new MyRAppCdkStack(app, 'MyRAppCdkStack');
