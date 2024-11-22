# Prabhu-k8s Notes

aws s3api create-bucket --bucket 9000436826 --region us-east-1

export KOPS_STATE_STORE=s3://prabhusamarla.tech

export NAME=devopsk8s.xyz

export KOPS_STATE_STORE=s3://prabhusamarla.tech

kops rolling-update cluster --yes


prabhusamarla.tech - purchased
prabhusamarla.tech - S3 bucket created
create MGM server to store all scripts


kops create cluster --name=prabhusamarla.tech --state=s3://prabhusamarla.tech --zones=us-east-1a --node-count=1 --node-size=t2.micro --master-size=t2.small --master-volume-size 10 --node-volume-size 8 --dns-zone=prabhusamarla.tech --yes

==============================================================================
export KUBECONFIG=./kubeconfig
cat ~/.kube/config
  
  
kops create cluster \
  --name=prabhusamarla.tech \
  --state=s3://prabhusamarla.tech \
  --zones=us-east-1a \
  --node-count=1 \
  --node-size=t2.small \
  --control-plane-size=t2.medium \
  --control-plane-volume-size=10 \
  --node-volume-size=10 \
  --dns-zone=prabhusamarla.tech \
  --ssh-public-key="~/.ssh/id_ed25519.pub" \
  --kubernetes-version=1.30.6 \
  --yes 



index.docker.io/sreeharshav/rollingupdate:v1
index.docker.io/sreeharshav/testcontainer:v1
 kubectl set image deployment nginx-deployment nginx=sreeharshav/rollingupdate:v1

=========================================================

kops update cluster --name prabhusamarla.tech --yes --state=s3://prabhusamarla.tech 

kops edit ig --name=prabhusamarla.tech control-plane-us-east-1a  --state s3://prabhusamarla.tech 

kops edit ig nodes-us-east-1a --state=s3://prabhusamarla.tech


kops delete cluster --name=prabhusamarla.tech --state s3://prabhusamarla.tech --yes

kops edit cluster prabhusamarla.tech --state=s3://prabhusamarla.tech

ssh -i ~/.ssh/id_ed25519 ubuntu@ec2-34-224-56-245.compute-1.amazonaws.com

kops get cluster prabhusamarla.tech --state=s3://prabhusamarla.tech -o yaml

kubectl get nodes -o wide

kops get ig --name prabhusamarla.tech

kubectl get pods -n kube-system

kubectl taint nodes i-092298e6ed3e9cf18 node.cloudprovider.kubernetes.io/uninitialized:NoSchedule-

ku edit rc name

ku label podname app-

ku label podname app=nginx

ku get pods --show-labels

index.docker.io/sreeharshav/testcontainer:v1
_________________________

# PODS

kubectl describe node i-0da36a04a754bfce1 | grep -i taint

kubectl taint nodes i-01177e1fc3a084cc0 node.cloudprovider.kubernetes.io/uninitialized-

kubectl taint nodes i-01177e1fc3a084cc0 node-role.kubernetes.io/control-plane:NoSchedule-




kubectl run testpod1 --image=index.docker.io/sreeharshav/rollingupdate:v1 

ubuntu@i-0a9c2cbe2d6316010:~$ kubectl expose pod testpod1 --port=8000 --target-port=80 --type=NodePort
service/testpod1 exposed

kubectl get svc


ssh -i ~/.ssh/id_ed25519 ubuntu@ec2-54-221-88-211.compute-1.amazonaws.com

=======================
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
        livenessProbe:
            initialDelaySeconds: 30
            periodSeconds: 5
            httpGet:
                path: /
                port: 80
				
------------------

A Readiness Probe checks if a container is ready to start receiving traffic. If a readiness probe fails, Kubernetes temporarily removes the pod from the pool of available pods until it passes the check again. 

A Liveness Probe checks if a container is still alive (i.e., running as expected). If the liveness probe fails, Kubernetes considers the container to be unhealthy and will restart it. This is useful for cases where the application might be running into a deadlock or is stuck in an unresponsive state.


NodePort
LoadBalencer - Classic load balancer (create one LB for one service is an drawback)


kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.11.2/deploy/static/provider/aws/deploy.yaml

https://kubernetes.github.io/ingress-nginx/deploy/#aws

https://github.com/kubernetes/ingress-nginx/blob/main/docs/deploy/index.md



ku create deploy deploy1 --image=index.docker.io/sreeharshav/rollingupdate:v1
ku create deploy deploy2 --image=index.docker.io/sreeharshav/rollingupdate:v3
ku create deploy deploy3 --image=index.docker.io/sreeharshav/testcontainer:v1
ku create deploy devopsk8s --image=index.docker.io/sreeharshav/testcontainer:v1

ku create deploy apple1 --image=nginx -n apple

ku expose deploy deploy1 --port=5000 --target-port=80 
ku expose deploy deploy2 --port=8000 --target-port=80
ku expose deploy deploy3 --port=9000 --target-port=80

ku expose deploy apple1 --port=8000 --target-port=80 -n apple

ku expose deploy apple1 --port=5000 --target-port=80 -n apple


echo "
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-svc-apple
  namespace: apple
spec:
  ingressClassName: nginx
  rules:
  - host: app3.prabhusamarla.tech
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: apple1
            port:
              number: 8000 
" | kubectl apply -f -
-------------------------------------

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-svc-2
  annotations:
    kubernetes.io/ingress.class: nginx
spec:
  rules:
  - host: www.prabhusamarla.tech
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: deploy2
            port:
              number: 8000














------------------------------


apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: my-app-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - host: my-app.example.com # Replace with your domain or use a wildcard like localhost
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-app-svc
            port:
              number: 80


----------------------------------------------
# Dashboards


echo "
apiVersion: v1
kind: ServiceAccount
metadata:
  name: admin-prabhu
  namespace: kubernetes-dashboard
  
" | kubectl create -f -

kubectl create token admin-prabhu -n kubernetes-dashboard

apiVersion: v1
kind: Secret
metadata:
  name: admin-user-token
  namespace: kubernetes-dashboard
  annotations:
    kubernetes.io/service-account.name: admin-user
type: kubernetes.io/service-account-token

-----------------------------------------------------

# Roles, Cluster ROle and Role binding

