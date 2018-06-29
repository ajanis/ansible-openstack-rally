## Rally Test Environment

Setting up an OpenStack Rally test environment custom tailored to an OpenStack Region

### Build Docker Container:

Set up ansible openstack build/deploy environment according to: https://engineering.paypalcorp.com/confluence/display/CRE/Ansible-Deploy

Clone or update openstack-rally repo if needed
```
git clone https://github.payapal.com/ajanis/openstack-rally.git ansible/openstack-rally
```
Build Docker Image for Rally service
```
cd ansible
docker build -t dockerhub.paypalcorp.com/iaas/rally --build-arg ansible_playbook=build_docker_rally.yml --build-arg ansible_inventory=hosts-paypal-ccg23 --build-arg ansible_vault=paypal-ccg23
docker push dockerhub.paypalcorp.com/iaas/rally:ansible-build
```

### Deploy Docker Container:

Sync your ansible playboooks to the proper ansible server
Run the ansible playbook to deploy the rally service
```
ansible-playbook -i hosts-paypal-ccg23 --vault-id paypal-ccg23 deploy_os_rally.yml 
```
```
docker run --name rally -d -t -v /etc/rally:/etc/rally -v /var/lib/rally:/var/lib/rally -v /var/log/rally:/var/log/rally --workdir /opt/rally --entrypoint /opt/rally/bin/rally dockerhub.paypalinc.com/iaas/rally:latest
```

### Create deployments:

Source the rc files and create the deployments "from environment"

```
source /var/lib/rally/rcfiles/adminrc
docker run -it rally deployment create --fromenv --name admin
```

### Run Tests:

```
docker run -it rally task start tasks/<task>.yml
```