FROM ruby:2.5.1

WORKDIR /xgboost-ruby
RUN git clone --recursive --jobs 4 --depth 1 https://github.com/dmlc/xgboost vendor/xgboost

WORKDIR vendor/xgboost
RUN git submodule update --remote
RUN make -j 4

WORKDIR ../..
ADD . .
RUN bin/setup

CMD rake
