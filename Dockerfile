FROM darthjee/scripts:0.3.1 as scripts

FROM darthjee/ruby_270:1.1.0 as base

COPY --chown=app:app ./ /home/app/app/

######################################

FROM base as builder

COPY --chown=app:app --from=scripts /home/scripts/builder/bundle_builder.sh /usr/local/sbin/bundle_builder.sh

ENV HOME_DIR /home/app
RUN bundle_builder.sh

#######################
#FINAL IMAGE
FROM base

COPY --chown=app:app --from=builder /home/app/bundle/ /usr/local/bundle/
RUN bundle install
