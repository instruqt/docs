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

*Note: topics are not available yet on the platform!*

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

# SDK

As of November 21, 2017, Instruqt also provides its own SDK environment. This allows users to create their own tracks with challenges.

## Guidelines for created content

- A challenge touches one small subject
- If multiple steps are required, chain challenges together in a track
- The right balance between “fun” and “educational”
- A challenge provides just enough hints
- Googling the solution is encouraged
- Don’t make a challenge itself too complex
- Don’t add too much text in the assignment. Use notes instead.

# Install SDK

## Installing Instruqt

Downloads:

- [Download the Instruqt SDK for Windows](https://storage.googleapis.com/instruqt-frontend/downloads/windows/instruqt.exe)
- [Download the Instruqt SDK for Linux](https://storage.googleapis.com/instruqt-frontend/downloads/linux/instruqt)
- [Download the Instruqt SDK for OSX](https://storage.googleapis.com/instruqt-frontend/downloads/osx/instruqt)

# Setup SDK

## Authenticating

```bash
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
After authenticating you will see that the CLI is storing credentials that it uses when executing the other commands.

# Tracks

## Creating a new track

To create a new track you can use the instruqt CLI tool, which is included in the SDK:

```bash
$ instruqt track create --title "My first track"
==> Creating track
==> Creating track files
    OK

    Created track directory and template:
      my-first-track/
      ├── config.yml
      └── track.yml
```

The `track create` command creates the track.yml and config.yml files with skeleton content.
If there already exists a track with the exact same title (and therefor identifier), you can specify another identifier by passing in the identifier flag.

```bash
instruqt track create --title "My first track" --identifier "my-other-first-track"
```

## Track content (track.yml)

After the track is created, fill out the track.yml and config.yml files with the needed information.
The track object contains the metadata that describes a track.

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
developers:
- bas@instruqt.com
published: false
```

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
| **developers** | list | The developers of this track. Also used in preview mode. |
| **published** | bool | Whether the track is published or not. |

## Track configuration (config.yml)

The config object defines the environment that will be created for the participant.
Depending on the selected template, other values need to be supplied in the configuration of the template.

```yaml
# config.yml
template: containers
configuration:
  Containers:
  - Image: alpine
    Name: shell
    Ports: []
    Privileged: false
    Resources:
      Memory: 128
    Shell: /bin/bash
```

#### Template

For now we only support the containers template. We will be expanding the template list in the future.

### Container

Each container can define it's needed resources and the ports it wants to expose.

| field | type | description |
| --- | --- | --- |
| **name** | string | The name you can use in your track.yml to connect to this container |
| **image** | string | The docker image to use for the container. |
| **ports** | list | A list of ports to expose. |
| **resources** | object | Optional, will default to 128MB Memory. The resources the container needs to run. |
| **privileged** | bool | If the container uses Docker in Docker, it will need to be running in privileged mode. |
| **shell** | string | The shell that will be started in the terminal window. Defaults to /bin/sh. |

### Ports

| field | type | description |
| --- | --- | --- |
| **name** | string | The name of the port. |
| **port** | int | The port that needs to be exposed on the inside. |

### Resources

To be able to limit the usage of a container, define the resources that it needs.

| field | type | description |
| --- | --- | --- |
| **memory** | int | The memory the container needs in MB. |

# Challenges

## Create challenges

If you have followed the previous step and have your track information and environment configuration set up, you can start creating challenges.

```bash
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

The `instruqt challenge create` command creates a new directory inside the track directory, named after the challenge. This directory includes the lifecycle scripts that control the challenge (check, cleanup, setup and solve).

## Create notes

The note is displayed when the infrastructure of your challenge is being created. You can display markdown text but also open a webpage.

To create a note, run:

```bash
instruqt note create \
  --title “Title of your note” \
  --type [text|video] \
  --challenge “slug-of-the-challenge”
```

This will add the note to your challenge. Check the track.yml for the result!

## Challenge content (track.yml)

The challenge create command fills the challenges property of your track.yml file with a new challenge. track.yml complete with challenge.

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
  - slug: first-challenge
    credits: 10
    title: First challenge
    teaser: A short description of the challenge.
    notes:
    - type: text
      title: This is a note
      contents: |
        The contents of the note.

        You can use any GitHub flavoured markdown.
    assignment: |
      The assignment the participant needs to complete in order to proceed.

      You can use any GitHub flavoured markdown.
    difficulty: basic
    timelimit: 900
    points: 50
    unlocks: []
    tabs:
    - type: terminal
      title: Shell
      hostname: shell
developers:
- bas@instruqt.com
published: true
```

### Challenge fields

| field | type | description |
| --- | --- | --- |
| **slug** | string | A unique ID within the scope of the track. |
| **credits** | int | The amount of credits used by this challenge. Not used yet. |
| **title** | string | The title of the challenge. |
| **teaser** | string | A short description of the challenge, shown in the challenge list. |
| **notes** | list | A list of notes that provide the user with context and background information. |
| **assignment** | string | A description of the actual challenge the user needs to complete. |
| **difficulty** | string | The difficulty of the track. Can be any of basic, intermediate, advanced and expert. |
| **timelimit** | int | The time in seconds before a challenge is automatically failed and stopped. |
| **points** | int | The amount of points a user will received if the challenge is completed. Not used yet. |
| **unlocks** | list | The list of challenge slugs that are unlocked upon completing the challenge. |
| **tabs** | list | A list of services that are exposed to the user in the browser, where each service has its own tab |

#### Note

| field | type | description |
| --- | --- | --- |
| **type** | string | The type of the note. Can be any of the following: text, url. |
| **title** | string | The title of the note, used in the table of contents of the challenge notes.|
| **contents** | string | Only usable with type=text. The contents of the note  |
| **url** | string | Only usable with type=url. The url link |

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

Describe different challenge setups:

- How to check challenges that use containers?
- How to check challenges that use a cloud provider?

#### Helper functions

```bash
# set-workdir sets the workdir for the challenge. The shell will start in this directory.

set-workdir $DIRECTORY


# fail-message exits the script with return code 1 and returns a message to the user.

fail-message $MESSAGE
```


#### Setup

This file is ran when starting the challenge. Use this script to:

- create files that are necessary for the challenge
- download and install specific binaries, that are not included in the docker image
- set the appropriate state of your services (i.e. start a docker container)

```bash
#!/bin/bash
# setup
echo "Setting up the challenge"
if [ !$EVERYTHING_WENT_WELL ]; then
  exit 1
fi
```

#### Check

This file is ran when you click the check button. Pointers:

- make sure you validate as strictly as possible. If you allow multiple ways to solve a challenge, the start situation of your next challenge will be much harder to predict.

```bash
#!/bin/bash
# check
echo "Checking the solution of the challenge"
if [ !$EVERYTHING_WENT_WELL ]; then
  fail-message "Your challenge failed because of [REASON]"
fi
```

#### Cleanup

This file runs when the check is successful. Use this script to:

- undo changes that are not required for the next challenge.

```bash
#!/bin/bash
# cleanup
echo "Cleaning up after the challenge"
if [ !$EVERYTHING_WENT_WELL ]; then
  exit 1
fi
```

#### Solve

This file is used for testing your check

```bash
#!/bin/bash
# solve
echo "Solving the challenge"
```

# Updating your track with challenges

## Building track

When you are happy with your changes, buil your track. This will import your track into the platform.

```bash
$ instruqt track build
==> Building track
==> Reading track definition
    OK
==> Compressing track
    OK
==> Sending track
    OK
```

This command will upload the track directory and trigger a build of the track. After a few minutes your changes will be visible on the instruqt platform.
