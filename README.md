# Minibox - A minimal commandbox image

The purpose of `foundeo/minibox` is to create the smallest possible docker container to run commandbox.

This container was built by [Foundeo Inc.](https://foundeo.com/) to provide a small container to run [Fixinator CFML Security Scanner](https://fixinator.app/) in CI.

## Architecture

The image currently uses the _Azul OpenJDK Alpine Linux Image_ as its base.

## Pre-warmed

The image is pre-warmed, meaning the CommandBox home has already been extracted - this should speed up the execution of commandbox.

## Usage

To test it out, you can simply run this command:

	docker run -it --rm foundeo/minibox:latest box version

## Tags

Right now it is just tagged under `latest` which should get you the latest version of commandbox.

## Thanks

Thanks to Brad Wood / Ortus for not only creating commandbox, but also creating box-thin and box-light which greatly simplified this process.