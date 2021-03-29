# Configure ECS Fargate as Jenkins Workers

This will walk through configuring ECS Fargate as on demand worker nodes for use with an existing jenkins server. 

## Prereqs

* AWS account with a default VPC setup
* Jenkins server with [ECS cloud plugin](https://plugins.jenkins.io/amazon-ecs/)
* Docker image that contains your tools and the jenkins inbound agent

## Deploy Required AWS resources

The included `ecs-agents.yml` file is an AWS [CloudFormation](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-guide.html) template that will create all of the necessary reources in your AWS account. You can upload this file via the CloudFormation [Designer](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/working-with-templates-cfn-designer-json-editor.html) or using the [CLI](https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-using-cli.html). 

1. Create a new stack with new resources 

![](images/create-stack.png)

2. Choose upload template file and upload the `ecs-agent.yml` and click Next

![](images/upload-template.png)

3. Give a stack name and click Next
4. No stack options are needed, click Next
5. Review and deploy.
6. In the stack outputs there will be an access key, secret key, and security group id that can be used in the coming steps.  Make note of these values!



## Configure Jenkins

This will walk through configuring the Jenkins ECS cloud plugin to connect to our newly created ECS cluster.

* Create a [Jenkins credential](https://www.jenkins.io/doc/book/using/using-credentials/) with the CloudFormation output access and secret key


### Configuration as code

 1. If you are configuring Jenkins with [configuration as code](https://www.jenkins.io/projects/jcasc/), then you can leverage the included `jenkins-cloud.yml` and append this into your configuration. you will need to modify the following fields: 
    
    * `cluster` - the arn of the ecs cluster
    * `jenkinsUrl` - the fqdn url that jenkins lives on
    * `credentialsId` - jenkins credentials id to connect to ECS. this is the credential ID created above
    * `securityGroups` - this will be the security group id from the CloudFormation output
    * `subnets` -  2 plulic subnets comma separated from your VPC.
    * `image` - the docker image you built above

### UI based config

1. Navigate to `Manage Jenkins -> Nodes and Clouds -> configure clouds`
2. Add a new cloud for ECS
3. Update the first section with the required info: 
   * `Name`
   * `ECS Credentials` created above
   * `Region`
   * Select the `ECS cluster` from the dropdown

![](images/jenkins1.png)

4. In the `advanced` section of the first block update the Jenkins URL
   
![](images/jenkins2.png)

5. In the `ECS Agent Templates` section update the label you want to use for Jenkins workers

![](images/jenkins3.png)

6. Update the Docker image you want to use that includes the inbound agent

![](images/jenkins4.png)

7. Set launch type to fargate

![](images/jenkins5.png)

8. Set the security group, subnets, and public ip fields

![](images/jenkins6.png)

9. Save and apply


## Test the agent

Jump over to [this section](https://github.com/pacphi/docker-terraform-and-jenkins/blob/main/README.md#author-jenkinsfile) of the repo to deploy a sample pipeline and be sure to use the label you defined above for the worker.

