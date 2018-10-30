FROM websphere-liberty:webProfile8
COPY Sum.war /config/dropins/
COPY server.xml /config/
RUN installUtility install --acceptLicense defaultServer