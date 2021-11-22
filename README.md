# K8s Playground


## Summary
A learning project for K8s internals:

Port of Kelsey Hightower's **[Kubernetes the Hard Way](https://github.com/kelseyhightower/kubernetes-the-hard-way)** from Google Cloud Platform to AWS.

Puts together the pieces to deploy a kubernetes cluster in a do-it-yourself manner to help understand how they fit.

## Requirements

Ansible >= 2.9 (tested on 2.9)
Terraform >= 0.12
'at' package - for scheduling destroy of the cluster

## Usage

If you do not already have an ssh key, generate one via `ssh-keygen`, using the defaults where prompted.

Then run `./temp-setup <time interval>` to temporarily generate the cluster. If unspecified, the default time interval is 30 minutes.

It will take some time for the infrastructure to provision and the ansible tasks to run.

Once the infrastructure is running, you can run kubectl commands to interact with the cluster.


# TODO

I'm currently troubleshooting the container networking. This deployment uses manual route config on the host machines (workers and controllers) to specify the route forwarding for pod ips. This is in contrast to AWS's ENI plugin model that would assign elastic IPs to hosts for each container (not very efficient at this scale).

Tests indicate that connecting from a worker node to a container in another worker works fine with the host ip forwarding.

However, manually connecting to a troubleshooting container has shown that the containers don't have an apparent route to the kubernetes ip.

# What I've learned

When possible, it's probably best to use a managed Kubernetes cluster and avoid rolling your own.
