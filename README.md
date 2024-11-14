docker build -t ubuntu-bind dns/
docker build -t nginx web/

docker run -d -p 53:53/udp -p 53:53/tcp --name bind9 ubuntu-bind
docker run -d -p 80:80/tcp --name web nginx

docker container cp bind9:/etc/bind/db.local .
docker container cp bind:/etc/bind/named.conf.local

docker container exec -it web bash
nslookup www.asa.br 127.0.0.1

git config --global user.name "Wellton" 
git config --global user.email welltongabrielkkj19@gmail.com

 docker container exec -it web bash
/usr/share/nginx/html