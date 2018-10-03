FROM strimzi/kafka-connect:0.7.0

EXPOSE 24224

USER root:root

RUN  yum install -y which && gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB && curl -sSL https://get.rvm.io | bash -s stable --ruby=2.5.1

ENV PATH="${PATH}:/usr/local/rvm/rubies/ruby-2.5.1/bin/:/usr/local/rvm/gems/ruby-2.5.1/bin/"
ENV GEM_PATH="/usr/local/rvm/gems/ruby-2.5.1/"
ENV GEM_HOME="/usr/local/rvm/gems/ruby-2.5.1/"

RUN /bin/bash -c 'source /etc/profile.d/rvm.sh && /usr/local/rvm/rubies/ruby-2.5.1/bin/gem install fluentd -v "~> 1.2.5" --no-ri --no-rdoc && chmod -R 777 /usr/local/rvm/gems/ruby-2.5.1 && chmod 777 /opt/kafka'

USER 1001:1001

RUN /bin/bash -c 'gem install bundler && gem install fluent-plugin-elasticsearch'

# Set labels used in OpenShift to describe the builder images
LABEL io.openshift.s2i.scripts-url=image:///opt/s2i \
      io.openshift.tags="builder"

# Set S2I folder
ENV S2I_HOME=/opt/s2i

# Copy S2I scripts
COPY ./scripts/ $S2I_HOME

CMD ["/opt/s2i/run"]
