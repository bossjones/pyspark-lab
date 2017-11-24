# Visualvm EC2 JMX(Can be used with DigitalOcean Droplet too)

*source: https://gist.github.com/IgorBerman/447657479f9f356c45ea7ba89c07324e*

```

1. Setup your process java properties
-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.port=1098 -Dcom.sun.management.jmxremote.rmi.port=1098 -Djava.rmi.server.hostname=127.0.0.1

2. ssh to your server on ec2 with a) port forwarding of 1098(jmx port) and b) with socks server on 10003
ssh -L 1098:127.0.0.1:1098 -D 10003 my.ec2.instance.com

3. Open visualvm with socks proxy on on same proxy port
jvisualvm -J-DsocksProxyHost=localhost -J-DsocksProxyPort=10003

4. create local jmx connection on localhost:1098 in visualvm

5. enjoy

```
