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



### exposing it using a cloud LB (AWS in that case)
