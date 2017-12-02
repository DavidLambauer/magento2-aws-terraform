
# tl;dr

* This is WIP
* Once it is finished, you can enter a single command and you will have a super crazy magento 2 cloud thing
* Don't use it yet

![Dont use it yet](http://tclhost.com/lBbKSec.gif)

# Todos:

* Add VPC's
* Add Cloudfront and S3 for Media Storage
* Add SES
* Add Worker for Crons
* Add Job to get SQL Backups. We already have RDS Snapshots, but it might be useful to have another SQL Dump from time to time.
* Add Cloudwatch Metrics
* Add Tests for InSpec

# Magento 2 AWS Terraform

Have you ever been annoyed by setting up a new server and the amount of
time you lost with stupid configurations? Especially for Magento, you
server setup will be complex and heavy.

You often don't have the time to configure a setup that is fully optimized
and follows the Magento 2 best practices. This repository tries to solve
this issue.

## What you can expect from this repository

This repository contains a terraform provisioned and optimized Magento 2
that can be deployed to AWS in minutes. Imagine a new customer signs a
contract and you'll be able to deploy his System in minutes.

You will find a `.tf` file for each resource that is used in AWS. Files
with a `_` prefix are used to structure the code.

## Prerequisites

If you haven't done anything with AWS yet, you should stop reading at
this section. I won't describe terraform, AWS or the benefits of IaC
in this repository. There are tons of resources out there, that will
help you to dig into within a couple of hours.

Let me recommend some resources:

- [Cloudonaut](https://cloudonaut.io/)
- [AWS in Action](https://cloudonaut.io/amazon-web-services-in-action-second-edition-is-in-the-works/)

- [A Comprehensive Guide to Terraform](https://blog.gruntwork.io/a-comprehensive-guide-to-terraform-b3d32832baca)
- [Terraform: Up & Running](https://www.terraformupandrunning.com/?ref=gruntwork-blog-comprehensive-terraform)

- [AWS Awesome List](https://github.com/donnemartin/awesome-aws) - A curated List of useful resources around AWS.

- [Free Tier Overview](https://aws.amazon.com/de/free/) - A Summary of Services that are free of charge for one year or more.
- [Getting Started Guides](https://aws.amazon.com/de/getting-started/resource-center/?nc2=h_ql_gs) - A Collection of Guides, that help you to get started with several services.
- [Simply Monthly Calculator](http://calculator.s3.amazonaws.com/index.html) - A Calculator to predict the costs of your specific setup.
- [TCO Calculator](https://awstcocalculator.com/) - AWS Total Cost of Ownership (TCO) Calculator to compare the cost of running your applications in an on-premises or colocation environment to AWS.
- [PHP Developer Center](https://aws.amazon.com/php/?nc1=f_dr) - Find tools to work with AWS and PHP.
- [AWS Blog](https://aws.amazon.com/blogs/aws/) - The official AWS Blog.
- [AWS DevOps Blog](https://aws.amazon.com/blogs/devops/) - An AWS Blog that focus DevOps Topics.
- [AWS Architecture Blog](https://www.awsarchitectureblog.com/) - An AWS Blog that focus on Architecture.
- [AWS Security Blog](https://aws.amazon.com/blogs/security/) - An AWS Blog that focus on Security.

## Before you start

Before you start with this repo, you should make sure you have
everything installed and activated.

You will need an activated AWS Account.
You will need terraform installed on you computer.

## What does it cost?

You will pay the amount of resources that you use. This guide makes use
of an Aurora Cluster that is more expensive than a standard db instance.
I do use at least two instances of EC2 and one Instance for Redis (Elasticache).

If you stick with the default, the whole setup should be between
$100-$200 a month (no guarantee).

# Run it

Let's setup our Magento 2 within minutes.

```shell
terraform apply
```

