# Heyjobs Challenge

Challenge is a rake project with as service to sync endpoint of ad_service with local saved campaigns

Challenge is using active_record and rspec gems for dealing with the database and applying automation test on the syncing service

Challenge is using docker and docker-compose to have the best way of running the environments through containers by default

Challenge is using ruby 2.5 and postgres which will be installed through docker.

The remote add service is added in an environmental variable called `AD_SERVICE_ENDPOINT` and added in the file
`heyijobs-docker/app.env` which can be changed any time.

A JSON data of the differences between the local campaigns and the remote one will be printed inside the console.

## Prerequisites
- Installing Docker and docker compose

## Installation

```bash
$ git clone https://github.com/moemenhusseinshaaban/heyjobs-challenge.git
$ cd PATH_To_HEYJOBS_CHALLENGE/
```
- run `docker-compose up -d`
- run `docker-compose start`
- run `docker-compose images` ==> to get heyjobs web container name
- run `docker exec -it HEYJOBS_CONTAINER_NAME rake db:migrate`
- run `docker exec -it HEYJOBS_CONTAINER_NAME rake db:seed`
- run `docker exec -it HEYJOBS_CONTAINER_NAME rspec` ==> for running test and making sure every thing working fine

## Installetion Notes:
HEYJOBS_CONTAINER_NAME will always be heyjobs-docker-web as it is fixed in docker-compose.yml file

## Database Rake Tasks:
- run `docker exec -it HEYJOBS_CONTAINER_NAME rake db:drop`
- run `docker exec -it HEYJOBS_CONTAINER_NAME rake db:create` => create database for development and test environments
- run `docker exec -it HEYJOBS_CONTAINER_NAME rake db:migrate` => migrate data for development and test environments
- run `docker exec -it HEYJOBS_CONTAINER_NAME rake db:seed` => apply seeds to the project to work on predefined date
- run `docker exec -it HEYJOBS_CONTAINER_NAME rake db:reset` => will drop, create and migrate database in one step

## About Seed Data:
A job that it's campaigns will be synced.
A predefined campaign data that will apply all below cases:
- A new campaign that is not local which will be created
- An updated campaigns which will apply changes to the local ones
- A deleted campaigns that will not be returned from the end point and in that case the local campaign's status will be assigned as deleted

## Usage

```bash
$ cd PATH_To_HEYJOBS_CHALLENGE/
```

## Campaigns For Specific Job

To sync campaigns of specific job you can pass the job_id to the rake task

Example:

- For job that has id=1

```bash
$ docker exec -it HEYJOBS_CONTAINER_NAME rake sync:campaigns[1]
```

## General Campaigns

Executing the command without job_id is allowed if there is no specific job applyied

Example:

```bash
$ docker exec -it HEYJOBS_CONTAINER_NAME rake sync:campaigns
```

## Test

To run the test use the command:

```bash
$ docker exec -it HEYJOBS_CONTAINER_NAME rspec
```
