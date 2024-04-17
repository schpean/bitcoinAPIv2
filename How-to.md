Enunt: 
Create Kubernetes cluster in Azure, AWS or GCP, using Pulumi or Terraform:

Setup K8s cluster with the latest stable version, with RBAC enabled.
The Cluster should have 2 services deployed – Service A and Service B:
Service A is a WebServer written in C#, Go or Python that exposes the following:
Current value of Bitcoin in USD (updated every 10 seconds taken from an API on the web, like https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD).
Average value over the last 10 minutes.
Service B is a REST API service, which exposes a single controller that responds 200 status code on GET requests.
Cluster should have NGINX Ingress controller deployed, and corresponding ingress rules for Service A and Service B.
Service A should not be able to communicate with Service B.


Prerequisites
Before proceeding, ensure you have the following prerequisites:

Access to a Kubernetes cluster (e.g., Azure Kubernetes Service)
Docker installed on your local machine
Azure Container Registry (ACR) for storing Docker images

Deployment Steps
Navigate in azure/serviceA folder using cd and a terminal.

Build Docker Image: Build your Docker image for the application using the docker build command.
    docker build -t  myswiftregistry.azurecr.io/service-a:v2 .
After we will push the image in Azure using this command: 
    docker push myswiftregistry.azurecr.io/service-a:v2
We will execute the same commands but with service-b instead in Azure/serviceB directory
    docker build -t  myswiftregistry.azurecr.io/service-a:v2 
    docker push myswiftregistry.azurecr.io/service-a:v2

Deploy k8s using the following commands:
terraform init
terraform plan
terraform apply

Let's verify deployment: 
    "kubectl get pods"  - the output should look like this.
    NAME                                    READY   STATUS    RESTARTS   AGE
    service-a-deployment-6f85cbdb49-56bgt   1/1     Running   0          9h 
    service-b-deployment-df475cd4-qqdkt     1/1     Running   0          9h 
    test-pod                                1/1     Running   0          78m

    "kubectl get services -A"- to view all services"
    NAMESPACE       NAME                                 TYPE           CLUSTER-IP     EXTERNAL-IP     PORT(S)                      AGE
    default         kubernetes                           ClusterIP      10.0.0.1       <none>          443/TCP                      36h
    default         service-a                            ClusterIP      10.0.200.118   <none>          5000/TCP                     26h
    default         service-b                            ClusterIP      10.0.178.44    <none>          5000/TCP                     10h
    ingress-basic   aks-helloworld-one                   ClusterIP      10.0.88.62     <none>          80/TCP                       33h
    ingress-basic   aks-helloworld-two                   ClusterIP      10.0.134.21    <none>          80/TCP                       31h
    ingress-nginx   ingress-nginx-controller             LoadBalancer   10.0.50.77     98.64.252.105   80:30108/TCP,443:30931/TCP   33h
    ingress-nginx   ingress-nginx-controller-admission   ClusterIP      10.0.237.94    <none>          443/TCP                      33h
    kube-system     kube-dns                             ClusterIP      10.0.0.10      <none>          53/UDP,53/TCP                36h
    kube-system     metrics-server                       ClusterIP      10.0.107.107   <none>          443/TCP                      36h

    We can try to access the serviceA using the ingress controller.
        Notice that ingress controller is accessible at this ip: 98.64.252.105
        Using the following command we can test the functionality of serviceA endpoint
            "curl 98.64.252.105/service-a"
            This should be the output:
            "
                StatusCode        : 200
                StatusDescription : OK
                Content           : {"average_over_last_10m":61887.23099999998,"current_value":61473.92,"number_of_elements":60}

                RawContent        : HTTP/1.1 200 OK
                                    Connection: keep-alive
                                    Content-Length: 93
                                    Content-Type: application/json
                                    Date: Wed, 17 Apr 2024 14:22:06 GMT

                                    {"average_over_last_10m":61887.23099999998,"current_value":61473.92,...
                Forms             : {}
                ...
                "
            Similar we can try for serviceB: "curl 98.64.252.105/service-b"

To check if serviceA can not comunicate to serviceB.
        kubectl exec -it service-a-deployment-6f85cbdb49-56bgt -n default -- sh
   This command should open shell prompt inside pod service-a-deployment-6f85cbdb49-56bgt
   After this make sure you have curl installed and try to access the other serviceB
        curl http://<service-b-cluster-ip>:<service-b-port>
        curl http://10.0.178.44:5000 - for my case.

Unfortunately, I did not managed to block the communication between those services and my output is the following.
PS C:\Users\Bogdan\Desktop\Azure> kubectl exec -it service-a-deployment-6f85cbdb49-56bgt -n default -- sh
# curl http://10.0.178.44:5000
{"message":"Merge"}

Thank you for your time!