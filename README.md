## Development Environment - Prerequisites
Regarding web api development strategy, there are many approaches in term of technology that could be used to develop, such as ASP.NET Core or NoteJS, etc. This article we choose ASP.NET Core Web API as it is part of MS technology stack.
1. MS Visual Studio. At the time of this demo Im using MS Visual Studio 2017.
1. As we are working on AWS, [AWS Toolkit for Visual Studio 2017 and 2019](https://marketplace.visualstudio.com/items?itemName=AmazonWebServices.AWSToolkitforVisualStudio2017) is an essential tool to help us with some pre-defined templates to create a new project for Lambda AWS function (web api with .net core). This also supports to publish the function from local into AWS directly via VS.
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
      - Comunicate with ECS via container agent running on each of the instances
      - Docker container-based deployment.
      - Deploy and manage both applications and infrastructure.
      - Pay for EC2 instances.
   - Fargate:
      - No EC2 instance types.
      - Support Docker and enables you to run and manage Docker containers (hosted by AWS).
      - Deploy and manage applications, not infrastructure.
      - Pay for requested compute resources when used.
## Demo - Application Architecture
1. High level

![A screenshot of the High level Application Architecture ](/images/APIGetway-ECS.png)

1. We will deploy a simple microservice (web API) to AWS ECS using EC2
