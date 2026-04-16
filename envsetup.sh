mkdir monitoring
cd monitoring/
git clone https://github.com/landroni/PromGraf-MLOps-Course-Student.git

cd PromGraf-MLOps-Course-Student/

##install docker-compose
# (.venv_monitoring) ubuntu@ip-172-31-33-192:~/monitoring/PromGraf-MLOps-Course-Student$ sudo apt list docker-compose
# Listing... Done
# docker-compose/noble,now 1.29.2-6ubuntu1 all [installed]
sudo apt-get install docker-compose


##venv
virtualenv .venv_monitoring
source .venv_monitoring/bin/activate 

##
q

##
make


##test api
curl -X 'POST' \
  'http://localhost:8080/predict' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
    "text": "What a spectacular shot from Steph Curry!"
  }'


