---
title: Instruqt SDK - API Reference

# language_tabs: # must be one of https://git.io/vQNgJ
#  - shell

search: true
---

# Introduction

Instruqt is an online learning platform. It teaches you by presenting bite-sized challenges that you need to complete in order to progress. Accompanying these challenges is the explanation of the tools and concepts, needed to complete them.

Through gamification features such as achievements, progression, rankings - but above all: interesting challenges - we try to keep the users engaged.

# Vocabulary

## Topic

The top tier, called topics, describes higher order subjects. Examples of topics are:

- AWS Computing and Networking
- Container Technology
- CI/CD

## Track

One tier down, these topics are split up into tracks. These are ordered lists of challenges, which are more technology focused.
Examples of tracks in the “AWS Computing and Networking” topic are:

- Creating Amazon EC2 instances
- Working with Elastic Load balancing
- Setting up high availability with auto-scaling

## Challenge

The bottom tier are the challenges, which are bite-sized problems that need to be solved.
Each challenge consists of the explanation of the concept and technology followed by a hands-on assignment.
Examples of challenges in the “Creating Amazon EC2 Instances” track are:

- Create EC2 instance from template
- Create a Security Group
- Launch the instance

## Participant

A participant is a user that has joined a track. Each participant gets their own environment in which the challenges are done.
Users can participate in multiple tracks, each resulting in an isolated environment.

## Organization

An organization owns topics and tracks. Users can be added to an orgnization using the Web SDK. When a user is part of an organization, he has access to all private topics and tracks of that organization.

## Developer

Tracks can have one or more developers. Developers are responisible for creating a track. When a user is a developer for a track, he can make changes to that track. Users do not have to be part of an organization to be added as a developer to a track.


# SDK

Instruqt provides both a Web and a CLI version of the SDK. The Web SDK can be activated by enabling it in your profile menu. To use the CLI, you'll need to [install](#install-cli) it.

## Guidelines for created content

- A challenge touches one small subject
- If multiple steps are required, chain challenges together in a track
- Try to find the right balance between “fun” and “educational”
- A challenge provides just enough hints
- Googling the solution is encouraged
- Don’t make a challenge too complex
- Don’t add too much text in the assignment, use notes instead


# Install SDK

## Installing Instruqt

Downloads the latest version from: [https://github.com/instruqt/cli/releases/latest](https://github.com/instruqt/cli/releases/latest)

## Authentication

```
$ instruqt auth login
==> Signing in to instruqt
==> Please open the following address in your browser and
    sign in with your Instruqt credentials:
==> http://localhost:15777/
==> Storing credentials
    OK
```

In order to create and build tracks, you will need to authenticate with instruqt in order to communicate with the builder backend.
The `instruqt auth login` command will output a URL that you need to open in your browser.
After authenticating you will see that the CLI is storing credentials that it uses when executing the other commands. After this, the credentials will refresh itself.

# Tracks

## Creating a new track

```
$ instruqt track create --title "My first track" --organization my-org-slug
==> Creating track
==> Creating track files
    OK

    Created track directory and template:
      my-first-track/
      ├── config.yml
      └── track.yml
```

To create a new track you can use the instruqt CLI tool, which is included in the SDK. The `track create` command creates the track.yml and config.yml files with skeleton content.

```
instruqt track create --title "My first track" --organization my-org-slug --identifier "my-other-first-track"
```

If there already exists a track with the exact same title (and therefor identifier), you can specify another identifier by passing in the identifier flag.


## Track content (track.yml)

```yaml
# track.yml
type: track
slug: my-first-track
icon: https://storage.googleapis.com/instruqt-frontend/img/tracks/default.png
title: My first track
teaser: A short description of the track.
description: |
  A long description of the track.

  You can use any GitHub flavoured markdown.
tags: []
challenges: []
owner: my-org-slug
developers:
- bas@instruqt.com
published: false
```

After the track is created, fill out the track.yml and config.yml files with the needed information.
The track object contains the metadata that describes a track.

| field | type | description |
| --- | --- | --- |
| **type** | string | The type of the track. Can either be track of sandbox. Defaults to track. |
| **slug** | string | A string that is the ID of the track. The value of the ID should be globally unique. |
| **icon** | string | The URL of the icon that is to be shown with the track. The size of the icon should be 48x48 pixels. |
| **title** | string | The title of the track. |
| **teaser** | string | A short description of the track, which is shown in the track list. |
| **description** | string | A full description of the track, which is shown at the track details. |
| **tags** | list | A list of strings that represent tags associated with the track. |
| **challenges** | list | A list of challenges that belong to the track. |
| **owner** | string | The slug of the organization that owns this track. |
| **developers** | list | The developers of this track. Developers can preview the track when it is not yet published. |
| **published** | bool | Whether the track is published or not. |


## Track configuration (config.yml)

```yaml
# config.yml
version: 2
containers:
- name: container
  image: alpine
  ports:
  - 8080
  - 9090
  resources:
    memory: 128
  shell: /bin/bash
  environment:
    ENV_VAR: value
    ANOTHER: one
virtualmachines:
- name: vm
  image: debian-9
  machine_type: g1-small
  pool_size: 1
  shell: /bin/bash
  environment:
    ENV_VAR: value
    ANOTHER: one
gcp_projects:
- name: gcp-project
  services:
  - cloudresourcemanager.googleapis.com
  - compute.googleapis.com
```

The config object defines the environment that will be created for the participant. Configurations support containers, virtual machines and GCP projects. Depending on the resource type, different values need to be supplied in the configuration file.


### Containers

Every container can define it's needed resources and the ports it wants to expose.

| field | type | description |
| --- | --- | --- |
| **name** | string | The name you can use in your track.yml to connect to this container |
| **image** | string | The docker image to use for the container. |
| **ports** | list | A list of port numbers to expose. |
| **resources** | object | Optional, will default to 128MB Memory. The resources the container needs to run. |
| **environment** | map | A map of key-value pairs that will be injected as environment variables |
| **shell** | string | The shell that will be started in the terminal window. Defaults to /bin/sh. |

### Container Resources

To be able to limit the usage of a container, define the resources that it needs.

| field | type | description |
| --- | --- | --- |
| **memory** | int | The memory the container needs in MB. |


### Virtual Machines

Every virtual machine can define it's needed resources and the ports it wants to expose.

| field | type | description |
| --- | --- | --- |
| **name** | string | The name you can use in your track.yml to connect to this VM. |
| **image** | string | The docker image to use for the container. See [https://www.terraform.io/docs/providers/google/r/compute_instance.html#image](https://www.terraform.io/docs/providers/google/r/compute_instance.html#image) for a list of valid values. |
| **machine_type** | string | The machine type of the VM. See [https://cloud.google.com/compute/docs/machine-types](https://cloud.google.com/compute/docs/machine-types) for an overview of available machine types |
| **preemptible** | boolean | Whether the virtual machine is [preemptible](https://cloud.google.com/compute/docs/instances/preemptible), defaults to false |
| **pool_size** | int | The size of the pool of VMs to have as hot standby. A value of 0 disables pooling. Defaults to 0. |
| **environment** | map | A map of key-value pairs that will be injected as environment variables |
| **shell** | string | The shell that will be started in the terminal window. Optional, defaults to /bin/sh. |


### GCP Projects

Every GCP Project can define the services that need to be enabled.

| field | type | description |
| --- | --- | --- |
| **name** | string | The display name of the GCP project that will be created |
| **services** | list | A list of services that should be enabled on the project. See [https://cloud.google.com/service-usage/docs/list-services](https://cloud.google.com/service-usage/docs/list-services) for all available services |


### Using GCP Projects

For every project, a set of environment variables `INSTRUQT_GCP_PROJECT_${NAME}_*` will be injected into the containers and virtual machines of this track. `${NAME}` will be replaced with the name of the GCP project (converted to upper case, dashes replaced with underscores, and non alphanumeric characters will be removed).

| environment variable | description |
| --- | --- |
| `INSTRUQT_GCP_PROJECTS` | Comma separated list of project names<br>Can be used to fill `${NAME}` in the variables below |
| `INSTRUQT_GCP_PROJECT_${NAME}_PROJECT_NAME` | Project Display Name |
| `INSTRUQT_GCP_PROJECT_${NAME}_PROJECT_ID` | Project ID |
| `INSTRUQT_GCP_PROJECT_${NAME}_USER_EMAIL` | Email address of user that has access to project |
| `INSTRUQT_GCP_PROJECT_${NAME}_USER_PASSWORD` | Password of user |
| `INSTRUQT_GCP_PROJECT_${NAME}_SERVICE_ACCOUNT_EMAIL` | Email address of services account for this project |
| `INSTRUQT_GCP_PROJECT_${NAME}_SERVICE_ACCOUNT_KEY` | Base64 encoded key for the services account |


### gcp-project-client container

```yaml
# config.yml
containers:
- name: gcp-project-client
  image: gcr.io/instruqt/gcp-project-client
  ports: [80]
  shell: /bin/bash

# track.yml
challenges:
- slug: my-challenge
  tabs:
  - type: service
    title: GCP Console
    hostname: gcp-project-client
    port: 80
    path: /
  - type: terminal
    title: gcloud cli
    hostname: gcp-project-client
```

There is also a GCP Project Client container available to expose links to the GCP Cloud Consoles for these projects, with the credentials required to login. It also includes the `gcloud` cli, with is preconfigured with all the service account keys for these projects.

To enable this, add the `gcr.io/instruqt/gcp-project-client` container to your config.yml. And add extra tabs to the challenges, where you want to expose the GCP Console or `gcloud` cli.


# Challenges

## Create challenges

```
$ instruqt challenge create --title "First challenge"
==> Creating challenge
==> Reading track definition
    OK
==> Creating challenge files
    OK

    Created challenge directory and template:
      my-first-track/
      └── first-challenge/
          ├── check-shell
          ├── cleanup-shell
          ├── setup-shell
          └── solve-shell
```

If you have followed the previous step and have your track information and environment configuration set up, you can start creating challenges. First of all, make sure you are in the newly created directory, in this example `my-first-track`.

## Create quizzes

```yaml
# track.yml
type: track
slug: my-first-track
icon: https://storage.googleapis.com/instruqt-frontend/img/tracks/default.png
title: My first track
teaser: A short description of the track.
description: |
  A long description of the track.

  You can use any GitHub flavoured markdown.
tags: []
challenges:
  - type: quiz
    slug: first-challenge
    title: First challenge
    teaser: A short description of the challenge.
    notes:
    - type: text
      contents: |
        Quiz time!
    assignment: |
      What is the answer to this very tricky question?
    answers:
      - No one knows
      - 42
      - Yes
      - None of the above
    solution:
      - 1
      - 2
    timelimit: 900
developers:
- hello@instruqt.com
published: true
```

If you want to create a quiz challenge, simply create a normal challenge as described above. There are a few extra fields to cover in the challenge section of the track.yml file. All fields for a challenge can be found below at the challenge fields section

| field | type | description |
| --- | --- | --- |
| **type** | string | The type of the challenge. Use ```quiz``` for quiz challenges. |
| **assignment** | string | The quiz question. |
| **answers** | list | A list with the possible answers in the challenge |
| **solution** | list | A list of numbers with the indexes of the correct answers. Multiple correct answers are possible. |
| **tabs** | list | There is no need to specify any tabs when creating a quiz challenge. |

In the given example the question asked will be ```What is the answer to this very tricky question?``` with the following answers possible:

- No one knows [index 0]
- 42 [index 1]
- Yes [index 2]
- None of the above [index 3]

The correct solutions are:

- 1 [index 1: 42]
- 2 [index 2: Yes]

The participant will need to provide only one correct answer to pass the quiz.


## Create notes

```
instruqt note create \
  --type [text|image|video] \
  --challenge “slug-of-the-challenge”
```

The note is displayed when the infrastructure of your challenge is being created. You can display markdown text but also open a webpage.

To create a note, run `instruqt note create --type <type> --challenge <challenge-slug>`.

This will add the note to your challenge. Check the track.yml for the result!


## Challenge content (track.yml)

```yaml
# track.yml
type: track
slug: my-first-track
icon: https://storage.googleapis.com/instruqt-frontend/img/tracks/default.png
title: My first track
teaser: A short description of the track.
description: |
  A long description of the track.

  You can use any GitHub flavoured markdown.
tags: []
challenges:
  - type: challenge
    slug: first-challenge
    title: First challenge
    teaser: A short description of the challenge.
    notes:
    - type: text
      contents: |
        The contents of the note.

        You can use any GitHub flavoured markdown.
    assignment: |
      The assignment the participant needs to complete in order to proceed.

      You can use any GitHub flavoured markdown.
    timelimit: 900
    tabs:
    - type: terminal
      title: Shell
      hostname: shell
organization: my-org-slug
developers:
- hello@instruqt.com
published: true
```

The challenge create command fills the challenges property of your track.yml file with a new challenge. track.yml complete with challenge.


### Challenge fields

| field | type | description |
| --- | --- | --- |
| **type** | string | The type of the challenge. Can eather be ```challenge``` or ```quiz``` |
| **slug** | string | A unique ID within the scope of the track. |
| **title** | string | The title of the challenge. |
| **teaser** | string | A short description of the challenge, shown in the challenge list. |
| **notes** | list | A list of notes that provide the user with context and background information. |
| **assignment** | string | A description of the actual challenge the user needs to complete or the challenge question if the challenge type is quiz. |
| **timelimit** | int | The time in seconds before a challenge is automatically failed and stopped. |
| **tabs** | list | A list of services that are exposed to the user in the browser, where each service has its own tab |
| **answers** | []string | An array of string that with the possible answers in the challenge |
| **solution** | []int | An array of integers with the indexes of the correct answers. Multiple correct answers are possible. |

#### Note

| field | type | description |
| --- | --- | --- |
| **type** | string | The type of the note. Can be any of the following: ```text```, ```image``` or ```video```. |
| **contents** | string | Only usable with type=text. The contents of the note  |
| **url** | string | Only usable with type=image or type=video. The url link of the image or url of the video |

#### tabs

##### type: terminal
| field | type | description |
| --- | --- | --- |
| **type** | string | The type of the tab. For a terminal, use type=terminal |
| **title** | string | The title of the tab |
| **hostname** | string | The name of the container used in this challenge. Must match the name of the container as described in your config.yml |


##### type: website
| field | type | description |
| --- | --- | --- |
| **type** | string | The type of the tab. Can be any of the following: terminal, website |
| **title** | string | The title of the tab |
| **url** | string | the url of the website opened in this browser. Must be a **https://** address |

##### type: service

| field | type | description |
| --- | --- | --- |
| **type** | string | The type of the tab, in this case "website" |
| **title** | string | The title of the tab |
| **name** | string | The name of the container used in this challenge. Must match the name of the container as described in your config.yml |
| **port** | int | The port used to connect to this container. Must match an exposed port in your config.yml |
| **path** | string | The path of the website, will be appended to the constructed URL. |

### Challenge scripts

Challenge scripts provide the automation hooks for interacting with the infrastructure of the track. There are 4 types of scripts:

| script | description |
| --- | --- |
| `setup-<hostname>` | This script is run when the user starts this challenge |
| `check-<hostname>` | This script is run when the user clicks on the "Check" button |
| `cleanup-<hostname>` | This script is run when the user has successfully completed the challenge |
| `solve-<hostname>` | This script is used for testing the track. |

For every challenge, you can add one of these scripts for every container or virtual machine in the track config. Use the `hostname` of the container of virtual machine to in the name of the scripts.


#### Setup

```bash
#!/bin/bash
# setup
echo "Setting up the challenge"
if [ !$EVERYTHING_WENT_WELL ]; then
  exit 1
fi
```

This file is ran when starting the challenge. Use this script to:

- create files that are necessary for the challenge
- download and install specific binaries, that are not included in the docker image
- set the appropriate state of your services (i.e. start a docker container)


#### Check

```bash
#!/bin/bash
# check
echo "Checking the solution of the challenge"
if [ !$EVERYTHING_WENT_WELL ]; then
  fail-message "Your challenge failed because of [REASON]"
fi
```

This file is ran when you click the check button. Pointers:

- make sure you validate as strictly as possible. If you allow multiple ways to solve a challenge, the start situation of your next challenge will be much harder to predict.


#### Cleanup

```bash
#!/bin/bash
# cleanup
echo "Cleaning up after the challenge"
if [ !$EVERYTHING_WENT_WELL ]; then
  exit 1
fi
```

This file runs when the check is successful. Use this script to:

- undo changes that are not required for the next challenge.


#### Solve

```bash
#!/bin/bash
# solve
echo "Solving the challenge"
```

This file is used for testing your check. It is used as part of a test cycle:

1. `setup`
1. `check` (expect failure)
1. `solve`
1. `check` (expect success)
1. `cleanup`


#### Helper functions

```bash
# set-workdir sets the workdir for the challenge. The shell will start in this directory.
set-workdir $DIRECTORY

# fail-message exits the script with return code 1 and returns a message to the user.
fail-message $MESSAGE
```

These are helper functions that are available for your challenge scripts.


# Updating your track with challenges

To sync your local and remote changes, you can use the `instruqt track pull` and `instruqt track push` commands.

## Pulling remote changes

```
$ instruqt-dev-local track pull
==> Pulling track for track my-track
    Updating local track:
    ├── track.yml
    ├── config.yml
    └── first-challenge/
        ├── check-shell
        ├── cleanup-shell
        ├── setup-shell
        └── solve-shell
```

To fetch changes made using the Web SDK, you can use the `instruqt track pull` command. If you do not have a local copy yet, you can pass the `--organization <organization-slug>` and `--slug <track-slug>` flags to specify which track you want to pull.

```
$ instruqt-dev track pull
==> Pulling track for track my-track
    [ERROR] Track has both remote and local changes

    Writing remote track to '*.remote' files, please update your local track before pushing. Either:
    1) Use `instruqt track pull --force` to overwrite your local changes, or
    2) Resolve the differences yourself using your favorite diff tool and editor.

    Writing track:
    ├── track.yml.remote
    ├── config.yml.remote
    └── first-challenge/
        ├── check-shell.remote
        ├── cleanup-shell.remote
        ├── setup-shell.remote
        └── solve-shell.remote
```

When you also have local changes, you can add a `--force` flag to overwrite these local changes. Otherwise the CLI will write the remote track to `*.remote` files.

## Pushing local changes

```
$ instruqt track push
==> Validating track
==> Reading track definition
    OK
==> Reading track configuration
    OK
==> Checking track config
    OK
==> Checking tabs
    OK
==> Checking scripts
    OK
==> Checking for leftover *.remote files
    OK
==> Reading track definition
    OK
==> Pushing track
    OK
==> Building track
    OK
==> Deploying track
    OK
==> Updating local track:
    ├── track.yml
    ├── config.yml
    └── first-challenge/
        ├── check-shell
        ├── cleanup-shell
        ├── setup-shell
        └── solve-shell
    OK
```

If you made changes to your track you will need to push these changes. By default, when pushing a track, it will also be built and deployed.

If only want to push the changes, but do not want to deploy it yet, add a `--deploy=false` flag. This might be useful for when you want to continue editing the track in the Web SDK, or if you want to share it with a fellow developer.

After pushing the track, it will be updated with the remote id's of your track and challenges. Be sure to reload the track.yml file in your editor to prevent overwriting of the id's. These id's will be used to match your local challenges with the remote challenges.


# Debugging your track

```
$ instruqt-dev track logs
==> Tailing logs for track my-track
2018/09/14 11:13:17 INFO: h84attob7rnw-8c64aa11957d79c2c40f3fb1b9d1096a: - module.core
2018/09/14 11:13:17 INFO: h84attob7rnw-8c64aa11957d79c2c40f3fb1b9d1096a: Initializing the backend...
...
```

When developing your track, you might run into situations where you need debug logs.

The CLI includes an `instruqt track logs` command, that you can use to get the logs of the instances of your track. All output of spinning up the environments for your track, as well as the output of the `check`, `cleanup` and `setup` scripts is available using this command.

This command will tail the logs until you cancel it (ctrl-c).

You can run this command from the folder where your `track.yml` is, or you can pass `--organization` and `--slug` flags to specify for which track you want to see the logs.
