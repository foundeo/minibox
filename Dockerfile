FROM azul/zulu-openjdk-alpine:8-jre AS build

RUN apk add zip unzip curl

RUN mkdir /opt/box
RUN curl --location -o /opt/box/box https://s3.amazonaws.com/downloads.ortussolutions.com/ortussolutions/commandbox/5.1.1/box-light

RUN chmod -R a+rx /opt/box/box 

RUN /opt/box/box config set verboseErrors=true

RUN /opt/box/box config set server.defaults.trayEnable=false

RUN /opt/box/box config set server.defaults.openBrowser=false

RUN /opt/box/box version

RUN /opt/box/box artifacts clean --force
# Remove any temp files
RUN rm -rf /root/.CommandBox/temp/*
# Remove any log files
RUN rm -rf /root/.CommandBox/logs/*
# Remove compiled CFML to save space lucee will have to recompile
RUN rm -rf /root/.CommandBox/engine/cfml/cli/cfml-web/cfclasses/*
# Remove cachebox caches
RUN rm -rf /root/.CommandBox/cfml/system/mdCache/*
# Cleanup CommandBox files
RUN rm -rfv /root/.CommandBox/cfml/system/config/server-icons/*.*
# Remove the felix cache
RUN rm -rf /root/.CommandBox/engine/cfml/cli/lucee-server/felix-cache/*

RUN rm -rf /root/.CommandBox/engine/cfml/cli/lucee-server/context/logs/*

RUN rm -rf /root/.CommandBox/engine/cfml/cli/lucee-server/context/context/admin/*

# These jar files are extracted again at runtime
# Except compress extension
RUN cp /root/.CommandBox/engine/cfml/cli/lucee-server/bundles/compress.extension* /tmp/
RUN cp /root/.CommandBox/engine/cfml/cli/lucee-server/bundles/org.lucee.zip4j-* /tmp/

RUN rm -f /root/.CommandBox/engine/cfml/cli/lucee-server/bundles/*.jar
RUN cp /tmp/compress.extension* /root/.CommandBox/engine/cfml/cli/lucee-server/bundles/
RUN cp /tmp/org.lucee.zip4j-* /root/.CommandBox/engine/cfml/cli/lucee-server/bundles/

RUN rm -f /root/.CommandBox/engine/cfml/cli/cfml-web/context/lucee-applet.jar
RUN rm -f /root/.CommandBox/engine/cfml/cli/cfml-web/context/lucee-admin.lar
RUN rm -f /root/.CommandBox/engine/cfml/cli/cfml-web/context/lucee-doc.lar

RUN curl --location -o /opt/box/box-thin https://s3.amazonaws.com/downloads.ortussolutions.com/ortussolutions/commandbox/5.0.2-alpha/box-thin

RUN mv /opt/box/box-thin /opt/box/box

RUN zip -q --delete /root/.CommandBox/lib/runwar-*.jar "org/bouncycastle/*"

#pack200 to reduce file sizes

#skip jgit
RUN mv /root/.CommandBox/lib/org.eclipse.jgit* /tmp/

RUN find /root/.CommandBox/ -type f -name "*.jar" -exec sh -c '/usr/lib/jvm/default-jvm/bin/pack200 --strip-debug --repack "$0"' {} \;

RUN mv /tmp/org.eclipse.jgit* /root/.CommandBox/lib/

#RUN find /usr/lib/jvm/default-jvm/ -type f -name "*.jar" -exec sh -c '/usr/lib/jvm/default-jvm/bin/pack200 --strip-debug --repack "$0"' {} \;

RUN find /root/.CommandBox/engine/cfml/cli/lucee-server/patches/ -type f -name "*.lco" -exec sh -c 'cp "$0" "$0.jar"' {} \;

RUN find /root/.CommandBox/engine/cfml/cli/lucee-server/patches/ -type f -name "*.lco" -exec sh -c '/usr/lib/jvm/default-jvm/bin/pack200 --strip-debug --repack "$0" "$0.jar"' {} \;

RUN rm -f /root/.CommandBox/engine/cfml/cli/lucee-server/patches/*.jar

FROM azul/zulu-openjdk-alpine:8-jre

COPY --from=build /opt/box /opt/box
COPY --from=build /root/.CommandBox/ /root/.CommandBox/ 

RUN chmod a+x /opt/box/box

RUN ln -s /opt/box/box /usr/bin/box



