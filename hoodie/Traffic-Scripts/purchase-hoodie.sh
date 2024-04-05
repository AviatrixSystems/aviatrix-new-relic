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
  --data-raw '[{"id":"03fef6ac-1896-4ce8-bd69-b798f85c6e0b","name":"Blue hoodie","description":"If you like blue clear skies as we rarely see here in Scotland, you will love this hoodie.","price":99.99,"count":1,"imageUrl1":"/images/blue_front.png","imageUrl2":"/images/blue_back.png","tags":[{"id":3,"name":"blue"},{"id":8,"name":"black"}],"sizes":[{"id":8,"name":"H","label":"Humongous"},{"id":3,"name":"M","label":"Medium"}],"size":{"id":8,"name":"H","label":"Humongous"}}]' \
  --insecure

curl $targeturl'/catalogue/checkout/'$cartid \
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
