# Monitoring-with-Terraform

**Terraform**
1. EC2 Instance kurulumu yapıyoruz.
2. Oluşturulan sunucu içerisinde kurulum yapılabilmesi için **provisioner** kullanarak localimizdeki ilgili dosyaları sunucuya yüklüyor ve **"remote-exec"** çalışmalarını sağlıyoruz.

İlk ve tek adım olarak ./terraform.sh komutunu çalıştırdığımızda bütün servisler çalışıyor durumda ve

 - Mongodb 
 - Mongodb Exporter - Mongodb den gelen metrikleri export edilmesi
 - Prometheus - Mongo exporter'dan metrikleri alması
 - Grafana - Metriklerin monitoring edilmesi

işlemlerini gerçekleştiriyor olacaktır.

- Localde sadece docker çalıştırarak monitoring işlemlerine localhost:3000 
- Instance içerinde ise public_ip:3000 
üzerinden erişebilirsiniz.

**Grafana**

Dashboard üzerinden metriklerini takibini yapmak için arayüzde birkaç adım gereklidir.

1. Add Data Source -> Prometheus -> URL: http://prometheus:9090 / save & test
2. Create -> Import -> Grafana Dashboard ID (12079) / Load
3. Select Prometheus -> Import







