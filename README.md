# Minibox - A minimal commandbox image

The purpose of `foundeo/minibox` is to create the smallest possible docker container to run commandbox.

This container was built by [Foundeo Inc.](https://foundeo.com/) to provide a small container to run [Fixinator CFML Security Scanner](https://fixinator.app/) in CI.

## Architecture

The image currently uses the _Azul OpenJDK Alpine Linux Image_ as its base.

Jave Version: 8

CommandBox Version: 5

## Pre-warmed

The image is pre-warmed, meaning the CommandBox home has already been extracted - this should speed up the execution of commandbox.

## Usage

To test it out, you can simply run this command:

	docker run -it --rm foundeo/minibox:latest box version

## Tags

The latest version is tagged under `latest` which should get you the latest version of commandbox and java. Builds are also tagged each month in the format `yyyy.mm`, for production use you may want to pin such a version. If you pin the current month there is a chance it may be updated again before the end of the month.

| Tag           | Java Version  | CommandBox Version |
| ------------- | ------------- | ------------------ |
| 2021.05       | 1.8.0_282     | 5.3.1+00392        |
| 2021.04       | 1.8.0_282     | 5.3.0+00349        |
| 2021.03       | 1.8.0_282     | 5.2.1+00295        |
| 2020.11       | 1.8.0_272     | 5.2.0+00280        |


## Thanks

Thanks to Brad Wood / Ortus for not only creating commandbox, but also creating box-thin and box-light which greatly simplified this process.
