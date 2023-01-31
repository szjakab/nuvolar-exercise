# Overview:
This document outlines the architecture and design of an HTTP API application composed of six Java microservices. The microservices are Dockerized and communicate with each other using RabbitMQ queues. The system also includes a RabbitMQ instance and an RDS cluster for data management. Concurrency is expected to be high, with several users consuming the API simultaneously.

# ​​Tools and Methodology:
1. For the development of the Java microservices, we will use Spring Boot framework. Spring Boot provides a simple and easy-to-use approach to creating stand-alone, production-grade Spring-based microservice applications.
2. We will use Docker to containerize the microservices. Docker allows us to package the microservices into containers, which can be easily deployed, scaled, and managed in a variety of environments.
3. For communication between microservices, we will use RabbitMQ deployed on AWS. This is  an open-source message broker software that implements the Advanced Message Queuing Protocol (AMQP). RabbitMQ provides a reliable, high-performance messaging system that can handle high concurrency.
4. For data management, we will use AWS RDS. RDS is a highly available, high-performance, and real-time transactional database designed for use in distributed environments. Lower risk of security issues as security patches and upgrades are managed by AWS. If the demand is high, we can easily deploy read replicas, to 
5. For version control, we will use Gitlab CI. Overall, GitLab CI can provide a seamless and efficient workflow for building, testing, and deploying our microservices, while being integrated with the GitLab and Kubernetes, and providing the necessary features for our system requirements.
6. For monitoring and alerting, we will use New Relic. New Relic helps to ensure the availability, performance, and stability of applications and infrastructure, enabling organizations to deliver better customer experiences.

**The system has been designed with security in mind, and uses best practices to ensure the data is secure. The system uses HTTPS to encrypt all communication, and access to the microservices and the RDS Cluster is restricted to authorized users only. For the docker files, only authenticated and authorized images were used to prevent the deployment of malicious code. The kubernetes cluster uses RBAC to restrict access to the Kubernetes API and to control who can perform actions within the cluster.**

# CI/CD Strategy:
1. We will use Gitlab CI as our continuous integration (CI) tool. Gitlab CI is a popular tool that can automate the building, testing, and deployment of our microservices.
2. We will use Gitlab as our source control management (SCM) system. Gitlab allows us to easily track changes to our code and collaborate with team members.
3. For continuous delivery (CD) target, we will use Kubernetes. Kubernetes is an open-source container orchestration system that can automatically deploy and scale our microservices based on load.
## Steps for the actual pipeline:
- Code Commit: Developers commit their code changes to a version control system (e.g. Git).
- Lint: The pipeline will run quality checks and security checks against the code. Recommended tools are SonarQube, OWASP Dependency Check and FindBugs.
- Build: Code is automatically built into a deployable Docker image.
- Deploy: The deployment package is deployed to a test environment for further testing and validation.
- Release: The deployment package is promoted to production if it meets the acceptance criteria.
- Monitor: The microservice is monitored in production for performance, availability, and errors.

# Reasons for Choices:
1. Spring Boot was chosen for its simplicity and ease of use in creating stand-alone, production-grade applications.
2. Docker was chosen for its ability to easily package and deploy the microservices in a variety of environments.
3. RabbitMQ was chosen for its ability to handle high concurrency and its support for the AMQP protocol.
4. RDS was chosen for its high availability and real-time transactional capabilities, which are well-suited for distributed environments.
5. GitLab CI is integrated with GitLab, the source control management (SCM) system we are using. This allows for a seamless CI/SCM workflow, where changes to the code can be automatically built, tested, and deployed. Also, it's easily extendable with Jarvis.
6. Gitlab was chosen as the SCM system because of its ease of use and collaboration features.
7. Kubernetes was chosen for its ability to automatically deploy and scale our microservices based on load.
8. New Relic was chosen for its integration with kubernetes, real-time monitoring and cross-platform visibility.