# ELKack

## From: [https://github.com/wolfbolin/crack-elasticsearch-by-docker](https://github.com/wolfbolin/crack-elasticsearch-by-docker)

Crack elasticsearch 7.x / 8.x / 9.X

Tested versions 7.X (as of crack-elasticsearch-by-docker readme):
* elasticsearch 7.17.2

Tested versions 8.X (as of crack-elasticsearch-by-docker readme):
* elasticsearch 8.2.0
* elasticsearch 8.8.1
* elasticsearch 8.9.1
* elasticsearch 8.10.1
* elasticsearch 8.11.1
* elasticsearch 8.12.1

Tested versions 9.X:
* elasticsearch 9.0.1

## Usage

Follow the "[Install Elasticsearch with a Debian package](https://www.elastic.co/docs/deploy-manage/deploy/self-managed/install-elasticsearch-with-debian-package)" official documentation

```shell
git clone https://github.com/Qwermit/ELKrack
```

Run script with version

```shell
cd ELKrack
chmod +x ./build_crack_jar.sh
sudo ./build_crack_jar.sh 9.0.2
```

Move cracked `x-pack-core-<version>.jar` to its destination

```shell
# make a backup
sudo cp /usr/share/elasticsearch/modules/x-pack-core/x-pack-core-$version.jar /usr/share/elasticsearch/modules/x-pack-core/x-pack-core-$version.jar.bak

# apply the crack
sudo cp ./output/x-pack-core-$version.jar /usr/share/elasticsearch/modules/x-pack-core/x-pack-core-$version.jar
```

## Licenses

Use one of the provided licenses in the [licenses](https://github.com/Qwermit/ELKrack) directory.

