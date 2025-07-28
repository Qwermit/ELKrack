#!/bin/bash
v=( ${VERSION//./ } )
branch="${v[0]}.${v[1]}"
version="${v[0]}.${v[1]}.${v[2]}"

# Define paths
CUSTOM_JAVAC="/usr/share/elasticsearch/jdk/bin/javac"
SYSTEM_JAVAC="$(command -v javac)"

CUSTOM_JAR="/usr/share/elasticsearch/jdk/bin/jar"
SYSTEM_JAR="$(command -v jar)"

# Determine which javac binary to use
if [ -x "$CUSTOM_JAVAC" ]; then
    JAVAC="$CUSTOM_JAVAC"
    echo "Using Elasticsearch bundled javac: $JAVAC"
else
    JAVAC="$SYSTEM_JAVAC"
    echo "Using system javac: $JAVAC"
fi

# Determine which jar binary to use
if [ -x "$CUSTOM_JAR" ]; then
    JAR="$CUSTOM_JAR"
    echo "Using Elasticsearch bundled jar: $JAR"
else
    JAR="$SYSTEM_JAR"
    echo "Using system jar: $JAR"
fi

# ---------

echo "Runtime environment"
echo -e "branch: \t\t$branch"
echo -e "version: \t\t$version"
echo -e "http_proxy: \t\t$HTTP_PROXY"
echo -e "https_proxy: \t\t$HTTPS_PROXY"

# Download source code
curl -o License.java -s https://raw.githubusercontent.com/elastic/elasticsearch/$branch/x-pack/plugin/core/src/main/java/org/elasticsearch/license/License.java
curl -o LicenseVerifier.java -s https://raw.githubusercontent.com/elastic/elasticsearch/$branch/x-pack/plugin/core/src/main/java/org/elasticsearch/license/LicenseVerifier.java
curl -o TransportXPackInfoAction.java -s https://raw.githubusercontent.com/elastic/elasticsearch/refs/heads/$branch/x-pack/plugin/core/src/main/java/org/elasticsearch/xpack/core/action/TransportXPackInfoAction.java

# Edit LicenseVerifier.java
sed -i '/void validate()/{h;s/validate/validate2/;x;G}' License.java
sed -i '/void validate()/ s/$/}/' License.java

# Edit LicenseVerifier.java
sed -i '/boolean verifyLicense(/{h;s/verifyLicense/verifyLicense2/;x;G}' LicenseVerifier.java
sed -i '/boolean verifyLicense(/ s/$/return true;}/' LicenseVerifier.java

# Edit TransportXPackInfoAction.java (patched from being XPackBuild.java)
sed -E -i 's|^([[:space:]]*)buildInfo = new XPackInfoResponse\.BuildInfo\(.*|\1buildInfo = new XPackInfoResponse.BuildInfo("Unknown", "Unknown");|' TransportXPackInfoAction.java

# Build class files
"$JAVAC" -cp "/usr/share/elasticsearch/lib/*:/usr/share/elasticsearch/modules/x-pack-core/*" LicenseVerifier.java
"$JAVAC" -cp "/usr/share/elasticsearch/lib/*:/usr/share/elasticsearch/modules/x-pack-core/*" TransportXPackInfoAction.java
"$JAVAC" -cp "/usr/share/elasticsearch/lib/*:/usr/share/elasticsearch/modules/x-pack-core/*" License.java

# Build jar file
cp /usr/share/elasticsearch/modules/x-pack-core/x-pack-core-$version.jar x-pack-core-$version.jar
unzip -q x-pack-core-$version.jar -d ./x-pack-core-$version

cp LicenseVerifier.class ./x-pack-core-$version/org/elasticsearch/license/
cp TransportXPackInfoAction.class ./x-pack-core-$version/org/elasticsearch/xpack/core/
cp License.class ./x-pack-core-$version/org/elasticsearch/license/

"$JAR" -cf x-pack-core-$version.crack.jar -C x-pack-core-$version/ .

rm -rf x-pack-core-$version

# Copy output
cp LicenseVerifier.* ./output
cp TransportXPackInfoAction.* ./output
cp x-pack-core* ./output
