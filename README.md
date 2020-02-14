# cached-docker

Execute docker build and push using docker caches with multi stage.

The docker multi stages are inferred from the Dockerfile.

## Installation

Download the binary [releases](./releases)

Linux

```
git clone https://github.com/devmasx/cached-docker ~/.cached-docker
sudo cp ~/.cached-docker/releases/linux/cached-docker /usr/local/bin/cached-docker
```

Mac OS

```
git clone https://github.com/devmasx/cached-docker ~/.cached-docker
sudo cp ~/.cached-docker/releases/macos/cached-docker /usr/bin/cached-docker
```

Or build the source code:

```
crystal build src/cached_docker.cr --release --static --no-debug -o /usr/bin/cached-docker
```

## Usage

```
cached-docker help
```

| Alias | Flag                 | Description                                                           | Default              |
| ----- | -------------------- | --------------------------------------------------------------------- | -------------------- |
| -i    | --image-name         | Image name without tag                                                |                      |
| -t    | --image-tag          | Image tag                                                             | Time in unix seconds |
|       | --build-params       | Add any docker build flag, --build-params="--build-arg=TOKEN=\$TOKEN" |                      |
| -f    | --file               | Name of the Dockerfile                                                | 'PATH/Dockerfile'    |
|       | --cache-stage-target | Name of the stage target for use in cache.                            |                      |
|       | --print              | Only print docker commands                                            | false                |
| -v    | --version            | Version                                                               |                      |
| -h    | --help               | Help for this command.                                                | false                |

Example:

```
cached-docker -i image-name
```

Execute this docker commands:

```
docker pull image-name || exit 0
docker pull image-name:cache-builder || exit 0
docker build --cache-from=image-name:cache-builder --cache-from=image-name --target builder .
docker build --cache-from=image-name:cache-builder --cache-from=image-name -t image-name -t image-name:1580121987 .
docker push image-name:cache-builder
docker push image-name:1580121987
docker push image-name
```

## Best practices for speeding up builds

To increase the speed of your Docker image build is by specifying a cached image that can be used for subsequent builds. You can specify the cached image by adding the --cache-from argument, which will instruct Docker to build using that image as a cache source.

Each Docker image is made up of stacked layers. Using --cache-from rebuilds all the layers from the changed layer until the end of the build; therefore using --cache-from is not beneficial if you change a layer in the earlier stages of your Docker build.

It is recommended that you always use --cache-from for your builds, but keep the following caveats in mind:

You need a previously built Docker image to cache from.
The cached image must be retrieved from a registry, which may add to the time it takes to build.

## Contributing

1. Fork it (<https://github.com/devmasx/cached-docker/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [Miguel Savignano](https://github.com/devmasx) - creator and maintainer
