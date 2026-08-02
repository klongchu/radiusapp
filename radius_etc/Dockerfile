FROM freeradius/freeradius-server:3.2.10

COPY _data/ /etc/freeradius/
RUN ln -sf ../sites-available/coa /etc/freeradius/sites-enabled/coa
RUN chmod -R go-w /etc/freeradius
