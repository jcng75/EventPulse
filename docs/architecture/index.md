# Project Architecture

This document outlines the architecture to be implemented in the project. The diagram for the proposed architecture is shown below.

![eventpulse-architecture](./img/EventPulseArchitecture.jpg)

# Requirements

- Implement a serverless architecture leveraging AWS services for scalability and reliability.
- Enable users to securely upload event data to an S3 bucket for processing.
- Automate event processing using AWS Lambda functions triggered by S3 uploads.
- Store processed event data in DynamoDB for efficient querying and retrieval.
- Provide RESTful API endpoints via API Gateway for user access to event data.
- Integrate AWS CloudWatch for centralized logging, monitoring, and alerting.
- Ensure auditing of all API interactions and data access for compliance.
- Design the solution to be highly available, fault tolerant, and cost-effective.

# Functionality

## User Functionalities
The following key functionalities are provided to users:
- Authenticated users can upload JSON objects directly to the S3 process bucket.
- Users have the ability to query their data stored in DynamoDB via secure API endpoints.
- Users receive notifications whenever an object fails to process successfully.

# Architecture Breakdown
**Components**

*S3*
- Serves as the main storage for incoming JSON event objects (process bucket).
- Objects that fail processing are automatically moved to a dedicated quarantine bucket for review.
- Provides highly durable and available storage for all event data.

*EventBridge*
- Monitors S3 for new object uploads and triggers processing workflows automatically.
- Enables a decoupled, event-driven architecture for scalable and real-time data handling.

*Lambda*
- Processes uploaded JSON objects and stores valid data in DynamoDB.
- Handles API requests for querying DynamoDB and managing objects in the quarantine bucket via API Gateway.
- Automatically scales across multiple availability zones for high availability and fault tolerance.

*DynamoDB*
- Stores processed event data in a flexible, highly available NoSQL database.
- Offers fast, cost-effective, and durable storage with multi-AZ support for reliability.

*SNS*
- Sends notifications to users about processing issues or query results.
- Enables timely communication and alerting for critical events.

*API Gateway*
- Provides RESTful endpoints for secure client-server communication.
- Acts as the entry point for user queries and quarantine management.

***Excluded from diagram***

*IAM*
- Manages permissions and access control for all AWS resources.
- Enforces strict security policies for users and services.

*CloudWatch*
- Aggregates logs and metrics from Lambda and other AWS services.
- Enables monitoring, troubleshooting, and alerting for the entire solution.

*CloudTrail*
- Tracks and audits all API calls and resource changes across the AWS environment.
- Provides compliance and security visibility for all operations.


# Downsides

- Increased complexity from integrating multiple AWS managed services. This was an intentional design choice to gain hands-on experience with these services, and the associated challenges are recognized and will be addressed.
- Cold start latency in Lambda functions may affect response times for infrequent workloads. However, as Lambda functions are designed to operate asynchronously with responses delivered via SNS, this impact is minimized.
- Debugging and tracing distributed, event-driven workflows can be challenging. This complexity is seen as an opportunity to develop skills in troubleshooting advanced cloud architectures.
- Monitoring and managing error handling (such as the quarantine bucket) requires ongoing attention. The risk is acknowledged and accepted as part of the solution's operational overhead.
