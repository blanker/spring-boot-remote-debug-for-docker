
/usr/lib/systemd/system/ngrokd.service

```
[Unit]
Description=ngrok
After=network.target

[Service]
ExecStart=/home/ubuntu/ngrok/ngrok-e/ngrok/bin/ngrokd -tlsKey=/home/ubuntu/ngrok/ngrok-e/ngrok/server.key -tlsCrt=/home/ubuntu/ngrok/ngrok-e/ngrok/server.crt -domain="hkshop.club" -httpAddr=":8081" -httpsAddr=":8082"

[Install]
WantedBy=multi-user.target
```
