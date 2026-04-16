##
cd monitoring/PromGraf-MLOps-Course-Student/
source .venv_monitoring/bin/activate 


##test api
curl -X 'POST' \
  'http://localhost:8080/predict' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
    "text": "What a spectacular shot from Steph Curry!"
  }'

curl -X 'POST' \
  'http://localhost:8080/predict' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
    "text": "The sun is a liquid."
  }'

curl -X 'POST' \
  'http://localhost:8080/predict' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
    "text": 2
  }'

curl -X 'POST' \
  'http://localhost:8080/predict' \
  -H 'accept: application/json' \
  -H 'Content-Type: application/json' \
  -d '{
    "asdf": "The sun is a liquid."
  }'

##FIXME use cron to fire requests on a cadence


##pour lancer le nouveau service Prometheus.
##NOTE: if modifying 'evaluation', need to power down first (docker-compose down) and then build again
# docker-compose down
docker-compose up --build -d

docker-compose up -d --build news-classifier-api
docker-compose up -d --build evaluation
# Redémarrer le service `prometheus`.
docker-compose up -d --build prometheus


##list
docker-compose ps
docker-compose down


##Prometheus UI
# http://localhost:9090/

##PromQL
# api_requests_total
# api_requests_total + api_requests_total
# api_request_duration_seconds_sum
# predictions_by_category_total
# api_requests_total{endpoint="/predict", method="POST", status_code="200"}
# api_requests_total{endpoint="/predict", method="POST", status_code="404"}
# api_requests_total{endpoint="/predict"}
# up{job="news_classifier_api"}
##gen
# prometheus_http_requests_total


##Metrics list
# http://localhost:8080/metrics
# HELP api_requests_total Total number of API requests
# TYPE api_requests_total counter
# HELP api_request_duration_seconds API request duration in seconds
# TYPE api_request_duration_seconds histogram
# HELP predictions_by_category_total Number of predictions by category
# TYPE predictions_by_category_total counter


# Alerts: **Pour tester :** Arrêtez le conteneur de votre API : `
docker-compose ps
docker-compose stop news-classifier-api
docker-compose start news-classifier-api


###################
##Grafana
# lancer grafana
docker compose up -d --build grafana

##Grafana UI
# http://localhost:3000
# admin / admin

##PromQL
# sum(api_requests_total{endpoint="/predict"})  ##nr tot requetes sur endpoint predict
# sum(api_requests_total{endpoint="/predict", status_code="200"})  ##nr tot requetes sur endpoint predict qui ont fini avec succes

##Alerts
##avg api_request_duration_seconds
# api_request_duration_seconds_sum{endpoint="/predict", method="POST"} / 
#   api_request_duration_seconds_count{endpoint="/predict", method="POST"}
#Panel pour la Latence Moyenne des Requêtes
#  "Average API Latency (1m)"
# rate(api_request_duration_seconds_sum[1m]) / rate(api_request_duration_seconds_count[1m])
#Panel pour le Taux d'Erreur API
# "API Error Rate"
# sum(rate(api_requests_total{status_code!="200"}[1m])) / sum(rate(api_requests_total[1m]))
#Panel pour le Nombre de Prédictions par Catégorie
# "Predictions by Category"
# sum(predictions_by_category_total) by (category)
#errors in 1m window
# api_requests_total{status_code!="200"}[1m]


##added evaluate endpoint
docker-compose down
make
# Testez le nouvel endpoint /evaluate : Utilisez la commande make evaluation qui va prélever un échantillon de données et interroger votre model sur l'endpoint /evaluate. Après avoir exécuté cette requête, la métrique model_accuracy_score devrait être mise à jour dans Prometheus.
make evaluation
docker-compose ps


##PromQL panels for dashboard
# Model Accuracy
# model_accuracy_score
# "Prediction Distribution by Category".
# sum (predictions_by_category_total) by (category)








