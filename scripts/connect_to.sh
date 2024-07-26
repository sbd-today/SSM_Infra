#!/bin/bash

if ! command -v fzf &> /dev/null; then
    echo "fzf is not installed. Please install fzf to use this script."
    echo "install fzf on Linux   sudo apt-get install fzf"
    echo "install fzf MacOS   brew install fzf"
    exit 1
fi

check_answer(){
  identity=$(aws sts get-caller-identity)
  #echo $identity
  printf "\n\n"
  printf "You are connect to [${account_id}] ${NC} account, Are you want to proceed? (Y/N)?"
  read answer
       if [ "$answer" != "${answer#[Yy]}" ] ;then
            echo "Ok"
        else
            exit 1
        fi
}

account_id=$(aws sts get-caller-identity --query Account --output text)

check_answer


selected_option=$(printf "Connect to EC2 Instance\nConnect to RDS" | fzf --header "select")
# Check if a selection was made
if [ -z "$selected_option" ]; then
    echo "No selection made. Exiting."
    exit 1
fi

portForwarding(){
  aws ssm start-session --target  $instance_id   --document-name AWS-StartPortForwardingSession     --parameters "portNumber"=["${server_port}"],"localPortNumber"=$local_port    --region us-west-2
}

connectWithSSM(){
  aws ssm start-session --target  $instance_id  --region us-west-2
}

connectRDS(){
    case "$option" in
        "Use ec2 private instance to connect RDS")
           tag="bloginstanceweb"
            getInstanceID
            ;;
        *)
            echo "Invalid selection."
            ;;
    esac

    for rds in $(aws rds describe-db-instances --query 'DBInstances[].DBInstanceArn' --region us-west-2 --output text); do
      tags=$(aws rds list-tags-for-resource --resource-name $rds --query 'TagList[?Key==`app_name` && Value==`mysql-db`]' --output json)
      if [[ $tags != "[]" ]]; then
          rds_id=$(aws rds describe-db-instances --query "DBInstances[?DBInstanceArn=='$rds'].Endpoint.Address" --region us-west-2 --output text)
	  echo $rds_id
          aws ssm start-session \
              --target $instance_id \
              --document-name AWS-StartPortForwardingSessionToRemoteHost \
              --parameters '{"host":["'$rds_id'"],"portNumber":["3306"], "localPortNumber":["3306"]}'
          exit 0
      fi
  done

}

getInstanceID(){
  instance_id=$(aws ec2 describe-instances --filters Name=instance-state-name,Values='running' "Name=tag:app_name,Values=$tag" --region us-west-2 --output text --query 'Reservations[*].Instances[*].{InstanceId:InstanceId}')
}

connectInstance(){
  instance_id=$(aws ec2 describe-instances --filters Name=instance-state-name,Values='running' "Name=tag:app_name,Values=$tag" --region us-west-2 --output text --query 'Reservations[*].Instances[*].{InstanceId:InstanceId,Name:Tags[?Key==`Name`]|[0].Value}' | fzf --header "select Instance Id to use")
  if [ -n "$instance_id" ]; then
    action=$(printf "Port forwarding\nGet into Server console" | fzf --header "select option")
    instance_id=$(echo $instance_id | awk '{print $1}')
      case "$action" in
          "Port forwarding")
              portForwarding
              ;;
          "Get into Server console")
              connectWithSSM
              ;;
          *)
              echo "Invalid selection."
              exit 1
              ;;
      esac

   else
     echo "No instance available"
  fi

}



connectToInstance(){
  tag="bloginstanceweb"
  server_port=80
  local_port=8080
  connectInstance
}

connectToRDS(){
  echo "connecting to RDS"
  tag="bloginstanceweb"
  getInstanceID
  option="Use ec2 private instance to connect RDS"
  connectRDS
}


case "$selected_option" in
    "Connect to EC2 Instance")
      connectToInstance
    ;;
    "Connect to RDS")
      connectToRDS
      ;;
    *)
      echo "Invalid selection."
      ;;
esac
