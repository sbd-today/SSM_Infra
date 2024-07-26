# SSM_Infra

## Create AMI 

Create AMI by executing following scripts root
```
./create-ami.sh

```

## Create Infra

To create infra, navigate to live folder and get inside the projer environment folder.

In case of dev, navigate to `live/dev` folder to create dev infra
```
cd live/dev
```

Execute the plan and see the changes. Skip the Error message show at the end.

```
./create_infra.sh
```

To destroy infra run 

```
./destroy_infra.sh
