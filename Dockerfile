FROM darthjee/ruby_gems:0.4.0 as base
FROM darthjee/scripts:0.1.7 as scripts

######################################

FROM base as builder

COPY --chown=app:app ./ /home/app/app/
COPY --chown=app:app --from=scripts /home/scripts/builder/bundle_builder.sh /usr/local/sbin/bundle_builder.sh

ENV HOME_DIR /home/app
RUN bundle_builder.sh

#######################
#FINAL IMAGE
FROM base

COPY --chown=app:app --from=builder /home/app/bundle/ /usr/local/bundle/
