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

export DB_DSN="mysql:host=db-{Ref:Environment}.{Ref:InternalDomainName};dbname=app_{Ref:Environment}"
export DB_USER="app_{Ref:Environment}"
export DB_PASSWD="{Ref:DbPwd}"

# Install PHP
yum -y install php56-cli php56-pdo php56-mysqlnd || error_exit "Failed to install git and php"
sed -i "s/.*date.timezone.*/date.timezone = \"America\/Los_Angeles\"/" /etc/php.ini

mkdir /var/www

aws s3 cp '{Ref:BuildPackage}' /var/www/app.phar

echo '<?php require("/var/www/app.phar");' > /var/www/router.php
nohup php -S 0.0.0.0:80 /var/www/router.php > /dev/null 2>&1 &