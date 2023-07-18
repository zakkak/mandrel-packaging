# Mandrel

Mandrel {{projectVersion}} is a downstream distribution of the [GraalVM for JDK 17](https://github.com/graalvm/graalvm-ce-builds/releases/tag/jdk-17.0.7) Community and [GraalVM for JDK 20](https://github.com/graalvm/graalvm-ce-builds/releases/tag/jdk-20.0.1) Community.

Mandrel's main goal is to provide a `native-image` release specifically to support [Quarkus](https://quarkus.io).
The aim is to align the `native-image` capabilities from GraalVM with OpenJDK and Red Hat Enterprise Linux libraries to improve maintainability for native Quarkus applications.

## How Does Mandrel Differ From Graal

Mandrel releases are built from a code base derived from the upstream GraalVM code base, with only minor changes but some significant exclusions.
They support the same native image capability as GraalVM with no significant changes to functionality.
They do not include support for Polyglot programming via the Truffle interpreter and compiler framework.
In consequence, it is not possible to extend Mandrel by downloading languages from the Truffle language catalogue.

Mandrel is also built slightly differently to GraalVM, using the standard OpenJDK project release of jdk 17.0.7+7 and 20.0.1+9.
This means it does not profit from a few small enhancements that Oracle have added to the version of OpenJDK used to build their own GraalVM downloads.
Most of these enhancements are to the JVMCI module that allows the Graal compiler to be run inside OpenJDK.
The others are small cosmetic changes to behaviour.
These enhancements may in some cases cause minor differences in the progress of native image generation.
They should not cause the resulting images themselves to execute in a noticeably different manner.

### Prerequisites

Mandrel's `native-image` depends on the following packages:
* freetype-devel
* gcc
* glibc-devel
* libstdc++-static
* zlib-devel

On Fedora/CentOS/RHEL they can be installed with:
```bash
dnf install glibc-devel zlib-devel gcc freetype-devel libstdc++-static
```

**Note**: The package might be called `glibc-static` or `libstdc++-devel` instead of `libstdc++-static` depending on your system.
If the system is missing stdc++, `gcc-c++` package is needed too.

On Ubuntu-like systems with:
```bash
apt install g++ zlib1g-dev libfreetype6-dev
```
## Windows

Mandrel {{projectVersion}} requires at least Visual Studio 2022 version 17.1.0 or later (C/C++ Optimizing Compiler Version 19.31 or later). You can no longer compile your applications using Visual Studio 2019 toolchain.

## Quick start

```
$ tar -xf mandrel-java17-linux-amd64-{{projectVersion}}.tar.gz
$ export JAVA_HOME="$( pwd )/mandrel-java17-{{projectVersion}}"
$ export GRAALVM_HOME="${JAVA_HOME}"
$ export PATH="${JAVA_HOME}/bin:${PATH}"
$ curl -O -J https://code.quarkus.io/d?e=io.quarkus:quarkus-resteasy-reactive
$ unzip code-with-quarkus.zip
$ cd code-with-quarkus/
$ ./mvnw package -Pnative
$ ./target/code-with-quarkus-1.0.0-SNAPSHOT-runner
```

### Quarkus builder image

Mandrel Quarkus builder image can be used to build a Quarkus native Linux executable right away without any GRAALVM_HOME setup.

As a part of a new version scheme of GraalVM Community Edition that aligns one GraalVM release with one JDK version, we added a new set of tags to our builder images:  jdk-17.0.7, jdk-17 and 23.0-jdk-17.

```bash
curl -O -J  https://code.quarkus.io/d?e=io.quarkus:quarkus-resteasy-reactive
unzip code-with-quarkus.zip
cd code-with-quarkus
./mvnw package -Pnative -Dquarkus.native.container-build=true -Dquarkus.native.builder-image=quay.io/quarkus/ubi-quarkus-mandrel-builder-image:{{projectVersion}}-java17
./target/code-with-quarkus-1.0.0-SNAPSHOT-runner
```

One can use the builder image on Windows with [Podman Desktop](https://podman-desktop.io/docs/Installation/windows-install) or Docker.

```batchfile
powershell -c "Invoke-WebRequest -OutFile quarkus.zip -Uri https://code.quarkus.io/d?e=io.quarkus:quarkus-resteasy-reactive"
powershell -c "Expand-Archive -Path quarkus.zip -DestinationPath . -Force
cd code-with-quarkus
mvnw package -Pnative -Dquarkus.native.container-build=true -Dquarkus.native.builder-image=quay.io/quarkus/ubi-quarkus-mandrel-builder-image:{{projectVersion}}-java17
podman build -f src/main/docker/Dockerfile.native -t my-quarkus-mandrel-app .
podman run -i --rm -p 8080:8080 my-quarkus-mandrel-app
```

### Changelog
{{changelogChanges}}

For a complete list of changes please visit https://github.com/graalvm/mandrel/compare/{{previousTagName}}...{{tagName}}

### JDK 20

 * JDK 20 builds are provided as a tech preview, dev builds. They will not receive any additional development. Our next addition to the contemporary LTS JDK 17 will be LTS JDK 21 builds.
 * AWT / graphics support in Mandrel JDK 20 is affected by #487 and will by fixed with July CPU release or later in JDK 21.

---
Mandrel {{projectVersion}}
OpenJDKs used: 17.0.7+7, 20.0.1+9
