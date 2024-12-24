

docker compose down

cd ../nginx

echo "shutdown nginx"
docker compose down
docker volume rm nginx_certs nginx_vhost nginx_html 

cd ../step-ca

rm backup_data -rf
mv data backup_data
mkdir data/secrets -p
echo "vDAB1Eew2qsp19APN9l8GiipEf5mHaE8" > data/secrets/password

docker compose create

echo "setup contaner"
docker run --rm  -v "$PWD/data:/home/step" smallstep/step-ca step ca init --name=yugmeu --dns=step.home --address=:9000 --provisioner=tmp --password-file=/home/step/secrets/password


#cp backup_data/secrets data/ -r
#cp backup_data/certs data/ -r
#cp backup_data/config/defaults.json data/config/defaults.json 


echo "update certificates"
sudo cp data/certs/root_ca.crt /usr/local/share/ca-certificates/root_ca.crt
sudo update-ca-certificates 


echo "start"
docker compose up -d

docker compose exec step-ca step ca provisioner remove tmp
docker compose exec step-ca step ca provisioner add acme --type ACME  --create --x509-min-dur=30m --x509-max-dur=3360h --x509-default-dur=1680h


docker compose restart

cd ../nginx

docker compose up -d

cd ../step-ca


