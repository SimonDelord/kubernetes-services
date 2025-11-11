# kubernetes-services
a repo showing the various types of services and how to use them .


## UDP Services

For this setup we simply create a simple python container listening on a specific UDP port.
  -  Dockerfile is the container file
  -  udplistener.py is the python script to listen on port UDP 5005

After you build this container, it will be stored into the local openshift registry and I use that to deploy one and map a service to it:
  - udp-pod.yaml (for the pod definition)
  - udp-service.yaml (for the service definition).

To test this, I run the following

``` echo "Hello UDP" | nc -u <target_ip> <target_port> ``` 

where target_ip is the service IP@ and target_port is 5005.


### exposing it using MetalLB

#### MetalLB configuration

For this setup I simply use an SNO (Single Node OpenShift) using Assisted Installer located at https://console.redhat.com/openshift/assisted-installer/clusters.

If you need a bit of help doing the assisted install you can have a look under https://github.com/SimonDelord/OCP-Assisted-Installer

For Metal LB these are the steps to follow:
 - install the Metal LB Operator
 - configure a MetalLB instance CR
 - create an IPAddressPool CR
 - create a L2Advertisment CR

All the configuration files are available under the MetalLB folder.

#### Creating services for this PoD

In this demo I create 2 services (one internal and one external). You don't need to have both, but I just want to show that it's possible to have multiple services pointing to the same PoD.
For the internal service you simply use a selector on one of the pod labels 

```
  selector:
    app.kubernetes.io/name: kubernetes-services-git
```

For the external service you then need to reference the MetalLB IPPoolAddress CR created in the previous step.

```
  annotations:
    MetalLB.universe.tf/address-pool: ip-addresspool-beehive
    metallb.io/ip-allocated-from-pool: ip-addresspool-beehive
```
as well as the selector.

```
  selector:
    app.kubernetes.io/name: kubernetes-services-git
```

#### Using Metal LB in front of an ingress

MetalLB can also be used to provide a load-balancing function in front of an ingress/routes (e.g for ports HTTP / HTTPS - typically TCP:80 and TCP:443).

The way to do this is to simply use an ingress controller (similar to what is described in this blog - https://www.redhat.com/en/blog/a-guide-to-ingress-controllers-in-openshift).

```
apiVersion: operator.openshift.io/v1
kind: IngressController
metadata:
  name: ingress-metal-lb
  namespace: openshift-ingress-operator
spec:
  nodePlacement:
    nodeSelector:
      matchLabels:
        node-role.kubernetes.io/worker: ''
  domain: apps.metal-lb.melbourneopenshift.com
  routeSelector:
    matchLabels:
      type: externalapplications
  endpointPublishingStrategy:
    loadBalancer:
      scope: External
    type: LoadBalancerService
```


### exposing it using a cloud LB (AWS in that case)
