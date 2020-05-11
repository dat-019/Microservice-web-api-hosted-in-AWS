## Development Environment
Regarding web api development strategy, there are many approaches in term of technology that could be used to develop, such as ASP.NET Core or NoteJS, etc. This article we choose ASP.NET Core Web API as it is part of MS technology stack.
1. MS Visual Studio. At the time of this demo Im using MS Visual Studio 2017.
1. As we are working on AWS, [AWS Toolkit for Visual Studio 2017 and 2019](https://marketplace.visualstudio.com/items?itemName=AmazonWebServices.AWSToolkitforVisualStudio2017) is an essential tool to help us with some pre-defined templates to create a new project for Lambda AWS function (web api with .net core). This also supports to publish the function from local into AWS directly via VS.
1. To use the AWS SDK for .NET with .NET Core, you can use the **AWSSDK.Extensions.NETCore.Setup** NuGet package. Ref [here](https://docs.aws.amazon.com/sdk-for-net/v3/developer-guide/net-dg-config-netcore.html).
1. As we are working on microservices and related disciplines, Docker is one of the most powerfully platform supporting this at the moment. We need to install [Docker Desktop on Windows](https://docs.docker.com/docker-for-windows/install/) in your Windows local.
1. Install the Linux Bash shell on Windowds 10 (Windows Subsytem Linux). This [article](https://www.howtogeek.com/249966/how-to-install-and-use-the-linux-bash-shell-on-windows-10/) shows how to install with step by step.
1. Install AWS Command Line Interface (AWS CLI) version 2 on Linux, as following [article](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-linux.html).
1. Install Docker in Windows Subsystem Linux, as following [article](https://medium.com/faun/docker-running-seamlessly-in-windows-subsystem-linux-6ef8412377aa).
   <b>Note</b>: This step can be optional if you already have installed Docker for Desktop.
   If Docker has been already running on Windows system, to enable docker can be used from Windows subsystem Linux, on the Bash shell command line of Windows subsystem Linux, do as following:
    - Docker can expose a TCP endpoint which the CLI can attach to.
         - This TCP endpoint is turned off by default; to activate it, right-click the Docker icon in your Windows taskbar and choose Settings, and tick the box next to "Expose daemon on tcp://localhost:2375 without TLS".
         - With that done, all we need to do is instruct the CLI under Bash to connect to the engine running under Windows instead of to the non-existing engine running under Bash, like this:
         ```Shell
         $ docker -H tcp://localhost:2375 images
         ```
         - There are two ways to make this permanent � either add an alias for the above command or export an environment variable which instructs Docker where to find the host engine:
         ```Shell
         $ echo "export DOCKER_HOST='tcp://localhost:2375'" >> ~/.bashrc
         $ source ~/.bashrc
         ```    
1. To be able to connect to EC2 Linux environment from your local Windows, we use Putty. This [link](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/putty.html) shows you how to do this.

## Microservice hosted in AWS
AWS has integrated building blocks that support the development of microservices.
Popular approaches are:
- AWS Lambda
   - No administration of infrastructure needed.
   - Support serveral programming languages.
   - Can be triggerd from other AWS Service or be called directly from external application.
   - Limitations: Ref [here](https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html).
- AWS Elastic Container Service (ECS), including EC2 instances and Fargate, is a logical grouping (cluster) of virtual machines/instances and related storage, memory, cpu management.
   - ECS EC2:
      - Remote (virutal) machines.
      - Comunicate with ECS via **container agent** running on each of the instances.
      - Docker container-based deployment.
      - Deploy and manage both applications and infrastructure.
      - Pay for EC2 instances.
   - Fargate:
      - No EC2 instance types.
      - Support Docker and enables you to run and manage Docker containers (hosted by AWS).
      - Deploy and manage applications, not infrastructure.
      - Pay for requested compute resources when used.
## Demo - Application Architecture
### High level

![A screenshot of the High level Application Architecture ](/images/APIGetway-ECS.png)

### Applicate Architecture - Deploy a simple microservice (Web APIs) to AWS ECS using EC2.

![A screenshot of the High level Application Architecture ](/images/Demo-AppInfrastructure.png)

- Elastic Load Banlancing service
   - 3 types: Application Load Balancing (ALB), Network Load Balancing (NLB) and Classic Load Balancing.
   - ALB is used by default if you are following the ECS wizard.
- AWS API Getway
   - Authentication & authorization.
   - Throttling.
   - Caching responses.
   - API lifecycle management: dev, QA, prod.
   - SDK generation.
   - API operations monitoring: API calls, latency & error rates.
   - CloudWatch alarms for abnormal API behaviors.
   - API keys for 3rd-party devs.
   - Work only with Network Load Balancing, not Application Load Balancing.
   - Reference [here](https://aws.amazon.com/blogs/architecture/using-api-gateway-as-a-single-entry-point-for-web-applications-and-api-microservices/) as the architecture for Using API Gateway as a Single Entry Point for Web Applications and API Microservices.

### Steps to work through
   1. Create your custom cluster in ECS
   1. Create api project(s) (using ASP.NET CORE WebApi project type) with Dockerfile to build and package an api project into docker image and stored in local docker repository.
   1. Create task defination (define docker container(s) with storage capacity / cpu usage from built image(s) in (2) above).
   1. Create build and deploy scripts (using AWS CLI with Bash)
   1. Deploy task defination into ECS
   1. Deploy built docker images into ECS Repository
   1. Create Elastic Load Balancing
   1. Create EC2 instances (two) with 'ecs-optimized' behavior. With 'ecs-optimized', the container agent is automatically deployed in the instance. To launch your container instance into a non-default cluster, choose the **Advanced Details** list. Then, paste the following script into the **User data** field, replacing your_cluster_name with the name of your cluster. Note that Amazon EC2 user data scripts are executed only one time, when the instance is first launched.
      ```Shell
         #!/bin/bash
         echo ECS_CLUSTER=your_cluster_name >> /etc/ecs/ecs.config
      ```
   1. Create new service with 2 tasks, with above created task defination and load balancing (type is Network Load Balancing). 
      The tasks will be created automatically and pull docker images from ECS repository into EC2 instacnes to create coresponding docker containers.
   1. Check existing the ECS Load balancing, a new target group was auto created with existing listener port (80). There are 2 targets inside the target group.
   1. Manually: 
      - Inside the load balaning, create new listener with port 1025.
      - Create new target group, add 2 remaining running docker containers as 2 targets in this target group. Note: make sure the listening ports are correct.
	   - Associate the listener with the target group
   1. Create new API Getway
   1. Create new VPCLink as the bridge between the Getway API and the Load Balancing
   1. Create API Getway resources
   1. For the client to call your API Getway, you must create a deployment and associate a state with it. Ref [here](https://docs.aws.amazon.com/apigateway/latest/developerguide/how-to-deploy-api-with-console.html)
   1. Testing methods.
