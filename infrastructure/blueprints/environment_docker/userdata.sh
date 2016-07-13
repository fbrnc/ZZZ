#!/usr/bin/env bash

CFN_SIGNAL_PARAMETERS='--stack {Ref:AWS::StackName} --resource AppAsg --region {Ref:AWS::Region}'

function error_exit {
    echo ">>> ERROR_EXIT: $1. Signaling error to wait condition..."
    /opt/aws/bin/cfn-signal --exit-code 1 --reason "$1" ${CFN_SIGNAL_PARAMETERS}
    exit 1
}
function done_exit {
    rv=$?
    if [ "$rv" == "0" ] ; then
        echo ">>> Signaling success to CloudFormation"
        /opt/aws/bin/cfn-signal --exit-code 0 ${CFN_SIGNAL_PARAMETERS}
    else
        echo ">>> NOT sending success signal to CloudFormation (return value: ${rv})"
        echo ">>> DONE_EXIT: Signaling error to wait condition..."
        /opt/aws/bin/cfn-signal --exit-code 1 --reason "Trap" ${CFN_SIGNAL_PARAMETERS}
    fi
    exit $rv
}
trap "done_exit" EXIT

yum update -y
yum install -y docker
service docker start

$(aws ecr get-login --region {Ref:AWS::Region})
docker run -d -t -i -p 8080:8080 {Ref:AWS::AccountId}.dkr.ecr.{Ref:AWS::Region}.amazonaws.com/nano:{Ref:Build}