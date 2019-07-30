FROM darthjee/ruby_gems:0.2.0 as base
FROM darthjee/scripts:0.0.3 as scripts

######################################

FROM base as builder

COPY --chown=app ./ /home/app/app/
COPY --chown=app:app --from=scripts /home/scripts/ ./

ENV HOME_DIR /home/app
RUN /bin/bash bundle_builder.sh

#######################
#FINAL IMAGE
FROM base
RUN mkdir lib/sinclair -p

USER root

COPY --chown=app:app --from=builder /home/app/bundle/gems /usr/local/bundle/gems
COPY --chown=app:app --from=builder /home/app/bundle/cache /usr/local/bundle/cache
COPY --chown=app:app --from=builder /home/app/bundle/specifications /usr/local/bundle/specifications
COPY --chown=app:app --from=builder /home/app/bundle/bin /usr/local/bundle/bin
COPY --chown=app:app --from=builder /home/app/bundle/extensions /usr/local/bundle/extensions

COPY --chown=app ./*.gemspec ./Gemfile* /home/app/app/
COPY --chown=app ./lib/sinclair/version.rb /home/app/app/lib/sinclair/
USER app
RUN bundle install
