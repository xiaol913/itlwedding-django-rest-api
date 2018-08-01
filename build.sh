#!/bin/bash

echo '========== Start to building =========='
sleep 2

echo '===== moving files ====='
sleep 2
cp -r ./db ../
cp -r ./nginx ../
cp -r ./sentry ../
cp ./docker-compose.yml ../

echo '===== creating netword ====='
sleep 2
docker network create shawnlive
cd ../sentry
mkdir -p data/{sentry,postgres}

echo '===== building sentry images(1) ====='
sleep 2
docker-compose build
docker-compose run --rm web config generate-secret-key | tail -1

echo '===== changing the .yml key ====='
sleep 2
echo "Please input the last column of last step"
read key
sed -i "/SENTRY_SECRET_KEY:/{s/''/'$key'/}" ./docker-compose.yml

echo '===== building sentry images(2) ====='
sleep 2
/bin/expect << -EOF
    set timeout 30
    spawn docker-compose run --rm web upgrade 
    expect {
        "Would you like to create a user account now*" { send "y\r"; exp_continue }
        "Email*" { send "admin@admin.com\r"; exp_continue } 
        "Password*" { send "123456\r"; exp_continue }
        "Repeat for confirmation*" { send "123456\r"; exp_continue }
        "Should this user be a superuser*" { send "y\r" }
    }
    expect eof
-EOF

echo '===== check sentry ====='
echo 'Did you create a user?("yes/no")'
read res
while [ $res == 'yes' ]; do
    if [ $res == 'yes' ]; then
        echo 'finish!'
    elif [ $res == 'no' ]; then
        echo 'Did upgrade finish?'
        read fin
        while [ $fin == 'yes' ]; do
            echo 'please input email:'
            read email
            echo 'please input password:'
            read passwd
            /bin/expect << -EOF
    set timeout 30
    spawn docker-compose run --rm web upgrade 
    expect {
        "Would you like to create a user account now*" { send "y\r"; exp_continue }
        "Email*" { send "$email\r"; exp_continue } 
        "Password*" { send "$passwd\r"; exp_continue }
        "Repeat for confirmation*" { send "$passwd\r"; exp_continue }
        "Should this user be a superuser*" { send "y\r" }
    }
    expect eof
-EOF
            echo 'Did upgrade finish?'
            read fin
            done
        echo 'please input "from sentry.models import Project'
        echo 'from sentry.receivers.core import create_default_projects'
        echo 'create_default_projects([Project])"'
        docker-compose run --rm web shell
        /bin/expect << -EOF
    spawn docker-compose run --rm web createuser
    expect {
        "Email*" { send "$email\r"; exp_continue } 
        "Password*" { send "$passwd\r"; exp_continue }
        "Repeat for confirmation*" { send "$passwd\r"; exp_continue }
        "Should this user be a superuser*" { send "y\r" }
    }
    expect eof
-EOF
        res='yes'
    else
        echo 'please input "yes" or "no"!'
    fi


echo '===== start sentry ====='
sleep 2
docker-compose up -d

echo '===== building web server images ====='
sleep 2
cd ../
docker-compose build
docker-compose up -d

echo '========== End of building =========='
