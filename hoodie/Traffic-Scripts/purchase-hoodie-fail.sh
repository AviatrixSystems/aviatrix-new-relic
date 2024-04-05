cartid=$(openssl rand -base64 1000 | tr -dc A-Za-z0-9 | head -c 23)

targeturl='http://35.179.26.185:8082'

curl $targeturl'/catalogue/cart/'$cartid \
  -H 'Accept: */*' \
  -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8' \
  -H 'Connection: keep-alive' \
  -H 'Content-Type: application/json' \
  -H 'DNT: 1' \
  -H 'Origin: http://18.130.121.233:3000' \
  -H 'Referer: http://18.130.121.233:3000/' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36' \
  --data-raw '[{"id":"01234567-8901-2345-6789-012345678901","name":"Glitchy Hoodie","description":"Will you dare to try the glitch?","price":100000,"count":9999,"imageUrl1":"/images/glitch_front.png","imageUrl2":"/images/glitch_back.png","tags":[],"sizes":[{"id":7,"name":"XXXL","label":"Extremely Large"},{"id":1,"name":"XS","label":"Extra Small"}],"size":{"id":7,"name":"XXXL","label":"Extremely Large"}}]' \
  --insecure

curl $targeturl'/catalogue/cart/'$cartid \
  -X 'POST' \
  -H 'Accept: */*' \
  -H 'Accept-Language: en-GB,en-US;q=0.9,en;q=0.8' \
  -H 'Connection: keep-alive' \
  -H 'Content-Length: 0' \
  -H 'Content-Type: application/json' \
  -H 'DNT: 1' \
  -H 'Origin: http://18.130.121.233:3000' \
  -H 'Referer: http://18.130.121.233:3000/' \
  -H 'User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36' \
  --insecure
