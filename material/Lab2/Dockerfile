FROM websphere-liberty:webProfile8
COPY --chown=1001:0 Sum.war /config/dropins/
COPY --chown=1001:0 server.xml /config/
RUN installUtility install --acceptLicense defaultServer
