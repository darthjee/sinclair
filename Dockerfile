FROM darthjee/ruby_gems:0.1.0

USER app
COPY --chown=app ./ /home/app/app/

RUN bundle install
