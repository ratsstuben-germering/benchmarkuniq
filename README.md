# benchmarkuniq

## uputa za korisnika

`$ chmod +x benchmarking.sh`

`$ sudo ./benchmarking.sh`

> skripta zbog tcpdumpa zahtjeva povišene privilegije.

0. skripta ce izbuildati `zadatak1`

1. Izvršiti stres test i tcpdump capture. 

2. Spremiti rezultate u ./result/{report1.html dump1.pcap}

3. Zaustaviti kontejnere. 

4. Stvoriti Swarm na osnovu slike iz `zadatak1`

5. Izvršiti stres test i tcpdump capture.

6. Spremiti rezultate u ./result/{report2.html dump.pcap}

7. Zaustaviti i obrisati Swarm.

Hvala Vam na zanimljivom zadatku i veoma teškom problemu pristupanja šeranom resursu zamaskiranog u diječju igru.  

Ovo je stablo projekta: 

./
├── benchmark.sh
├── py
│   ├── b1.py
│   └── b2.py
├── README.md
├── result
├── zadatak1
│   ├── app
│   │   ├── app.py
│   │   └── requirements.txt
│   ├── docker-compose.yml
│   └── Dockerfile
└── zadatak2
    └── docker-compose.yml
