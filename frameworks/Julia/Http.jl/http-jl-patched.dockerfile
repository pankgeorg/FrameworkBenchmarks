FROM julia:1.9.3

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -yqq && apt-get install -y
RUN apt-get update -yqq && apt-get install -y wget

COPY ./Project.toml ./Manifest-1.toml ./
RUN mv Manifest-1.toml Manifest.toml
# This step takes a lot of time, let's aggressively cache it
RUN julia --project=. -e 'import Pkg; Pkg.instantiate();'

# Files
COPY ./ ./
RUN mv ./Manifest-1.toml ./Manifest.toml

RUN chmod +x run.sh

EXPOSE 8080
# running multiple processes doesn't seem to make any sense
# https://docs.julialang.org/en/v1/stdlib/Sockets/#Base.bind


CMD ./run.sh