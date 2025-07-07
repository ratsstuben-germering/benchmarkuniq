#!/bin/bash
sleep 1
echo "	Benchmark 1 i 2 oba traju 20 sekundi."
sleep 2
echo " 	Simulacija 4000 usera sa spawn rate-om 100 po sekundi. "
sleep 2
echo "	Svaki user ceka izmedu 0.1 i 1 sekundu prije nego salje novi zahtjev."
sleep 2
echo "	U pozadini tcp dump snima promet."
echo "  Pokrenite skriptu kao superuser.(sudo)"
sleep 2
echo "	Zbog sigurnosnih razloga runnajte u sandboxu."
sleep 2


echo " Instaliram python dependencies"
sleep 1

python3 -m venv venv
chmod +x ./venv/bin/activate
./venv/bin/activate
./venv/bin/pip install locust

echo " Buildam zadatak1 ..." 
sleep 1

docker compose --project-directory zadatak1 up -d --build

sleep 5
echo "	Benchmark 1 pocinje . . . "

./venv/bin/locust -f py/b1.py -u 4000 -r 100 --headless --run-time 20s --html result/report1.html  & \
timeout 20 tcpdump -i lo tcp port 5001 -w result/dump1.pcap > /dev/null 2>&1
echo "------------------------------------------------------------"
echo "	Benchmark 1 gotov. Rezultati su spremljeni u ./result/report1.html"
sleep 3

echo "	Gasim kontejnere..."
containers=$(docker ps -q)
for c in $containers; do
    echo "$c"
    docker stop "$c"
done
echo "  spavam 5s"
sleep 5


echo "	Buildam zadatak 2..." 
sleep 1
docker swarm init
docker stack deploy -c zadatak2/docker-compose.yml deset-flasha-jedan-blagajnik

LOCAL_IP=$(ip route get 8.8.8.8 | awk '{print $7; exit}')

echo "	Benchmark 2 pocinje . . . "
echo "  Spavam 5 sekundi da se svi servisi podignu ..."
sleep 5
./venv/bin/locust -f py/b2.py -u 4000 -r 100 --headless \
       		--run-time 20s \
		--host="http://$LOCAL_IP:5000"\
		--html result/report2.html  & \
timeout 20 tcpdump -i any tcp and dst host "$LOCAL_IP" and dst port 5000 -w result/dump2.pcap > /dev/null 2>&1

echo " Gasim servise, zaustavljam swarm.."
services=$(docker service ls -q)
if [ -n "$services" ]; then
  for service in $services; do
    docker service rm "$service"
  done
fi
sleep 5
docker swarm leave --force
echo "---------------------------------------------------------------"
echo " Benchmarki su gotovi. Rezultati su u ./result direktoriju"
echo " Kontejneri su zaustavljeni. Swarm je zaustavljen i obrisan"
echo " ______________________________________________________________"
sleep 1
