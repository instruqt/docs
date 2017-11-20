---
title: API Reference

# language_tabs: # must be one of https://git.io/vQNgJ
#  - shell

search: true
---

# Introduction
Instruqt is an online learning platform. It teaches you by presenting bite-sized challenges that you need to complete in order to progress. Accompanying these challenges is the explanation of the tools and concepts, needed to complete them.

Through gamification features such as achievements, progression and rankings we try to keep the users engaged.

# Vocabulary
## Topic
The top tier, called topics, describes higher order subjects. Examples of topics are:
- AWS Computing and Networking
- Container Technology
- CI/CD

## Track
One tier down, these subjects are split up into tracks. These are ordered list of challenges, which are more technology focused.
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
Intro...

# Setup

## Authenticating
```bash
$ instruqt auth login
==> Signing in to instruqt
==> Please open the following address in your browser and
    sign in with your Instruqt credentials:
==> http://localhost:3000/
==> Storing credentials
    OK
```   
In order to create and build tracks, you will need to authenticate with instruqt in order to communicate with the builder backend.
The `auth login` command will output a URL that you need to open in your browser.
After authenticating you will see that the CLI is storing credentials that it uses when executing the other commands.

## Adding keys
```bash
$ instruqt keys add --file ~/.ssh/id_rsa.pub
==> Adding key
    OK

    Added key:
      SHA256:bOVasFWRg/dc7ZxWT7+mh2aB...
```   
Add your SSH public key to be able to build your track. With the file flag you can specify where your public key file is located.

## Listing keys
```bash
$ instruqt keys list
==> Listing known keys

    ID                       FINGERPRINT
    yzxMEQ-b6a8826283...     SHA256:bOVasFWRg/dc7ZxWT7+mh2aB...
```
To see if the key was successfully added, use the `keys list` command to list all of your added keys.
Make sure your key is listed before carrying on.

## Create track
```bash
$ instruqt track create --title "My first track"
==> Creating track
==> Checking if the track does not already exist remotely
    OK
==> Creating track files
    OK

    Created track directory and template:
      my-first-track/
      ├── config.yml
      └── track.yml
==> Setting up remote
    OK
==> Initializing repository
    OK
==> Adding remote
    OK

    Added git remote:
      instruqt git@tracks.instruqt.com:my-first-track.git
```
To create a new track you can use the instruqt CLI tool, which is included in the SDK.

The `track create` command creates the track/track.yml and track/config.yml files with skeleton content.
Remotely it creates a git repository with credentials and hooks already set up. Once the process completes, it outputs the remote git repository that  builds the track.

```bash
$ instruqt track create --title "My first track" --identifier "my-other-first-track"
```

If there already exists a track with the exact same title (and therefor identifier), you can specify another identifier by passing in the identifier flag.

## Track content
After the track is created, fill out the track.yml and config.yml files with the needed information.
The track object contains the metadata that describes a track.

```yaml
# track.yml
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
```

| field | type | description |
| --- | --- | --- |
| **slug** | string | A string that is the ID of the track. The value of the ID should be globally unique. |
| **icon** | string | The URL of the icon that is to be shown with the track. The size of the icon should be 48x48 pixels. |
| **tags** | list | A list of strings that represent tags associated with the track. |
| **title** | string | The title of the track. |
| **teaser** | string | A short description of the track, which is shown in the track list. |
| **description** | string | A full description of the track, which is shown at the track details. |
| **challenges** | list | A list of challenges that belong to the track. |
| **services** | list | A list of the services to expose to the user when doing a challenge. |
| **developers** | list | A list of allowed email addresses that can build the track. |

## Configuration
The config object defines the environment that will be created for the participant.
Depending on the selected template, other values need to be supplied in the configuration of the template.

```yaml
# config.yml
template: containers
configuration:
  Containers:
  - Image: gcr.io/instruqt/shell:latest
    Name: shell
    Ports:
    - Exposed: true
      Name: shell
      Port: 8080
    Privileged: false
    Resources:
      Memory: 128
```

| field | type | description |
| --- | --- | --- |
| **template** | string | The template that will be used to create the user environment. Other options include gcloud, aws and azure. |
| **configuration** | object | The configuration of the template. |

## Templates
For now we only support the `containers` template. We will be expanding the template list in the future.

## Configuration
The configuration specifies the variables with which the participant environment is created.

## Containers
The containers configuration template defines which containers to run and how to expose them.

| field | type | description |
| --- | --- | --- |
| **containers** | list | A list of containers that should be started in the user environment. |

## Container
Each container can define it's needed resources and the ports it wants to expose.

| field | type | description |
| --- | --- | --- |
| **name** | string | The name the container will be reachable as. |
| **image** | string | The docker image to use for the container. |
| **ports** | list | A list of ports to expose. |
| **resources** | object | Optional, will default to 128MB Memory. The resources the container needs to run. |
| ** privileged** | bool | If the container uses Docker in Docker, it will need to be running in privileged mode. |

## Ports
Ports that are marked as `exposed: true` will be visible to the users when doing challenges.

| field | type | description |
| --- | --- | --- |
| **name** | string | The name of the port. |
| **port** | int | The port that needs to be exposed on the inside. |
| **exposed** | bool | Wether or not the container should be reachable from the user's browser. |

## Resources
To be able to limit the usage of a container, define the resources that it needs.

| field | type | description |
| --- | --- | --- |
| **memory** | int | The memory the container needs in MB. |

## Create challenge
Now that the track information and environment configuration are set up, start creating challenges.

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
          ├── check
          ├── cleanup
          ├── setup
          └── solve
```

The `challenge create` command creates a new directory inside the track directory, named after the challenge. This directory includes the lifecycle scripts that control the challenge.

| script | stage | description |
| --- | --- | --- |
| setup | Starting challenge | Prepare the challenge for the user |
| check | Checking challenge | Check the user solution for the challenge |
| solve | Testing challenge | Programmatically solve the challenge |
| cleanup | Completing challenge | Cleanup the environment after challenge |

The command also creates a challenge entry in the track/track.yml file, to put the details of the challenge.

```yaml
# track.yml
# challenges:
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
      internal:
      - type: terminal
        title: Shell
        name: shell
        port: 80
      external: []
```

| field | type | description |
| --- | --- | --- |
| slug | string | A unique ID within the scope of the track. |
| title | string | The title of the challenge. |
| teaser | string | A short description of the challenge, shown in the challenge list. |
| difficulty | string | The difficulty of the track. Can be any of basic, intermediate, advanced and expert. |
| timelimit | int | The time in seconds before a challenge is automatically failed and stopped. |
| unlocks | list | The list of challenge slugs that are unlocked upon completing the challenge. |
| assignment | string | A description of the actual challenge the user needs to complete. |
| notes | list | A list of notes that provide the user with context and background information. |
| services | list | A list of services that are exposed to the user in the browser. |















### Note
... Description of a note.
Each of the note types have the following fields.

| field | type | description |
| --- | --- | --- |
| type | string | The type of the note. Can be any of the following: text, video or image. |
| title | string | The title of the note, used in the table of contents of the challenge notes.|

### Text note
A text note presents a piece of markdown to the user.

| field | type | description |
| --- | --- | --- |
| contents | string | The contents of the note. |

### Video note
A video note presents a video player to the user.

| field | type | description |
| --- | --- | --- |
| url | string | A embed link to the video. |

### Image note
An image note presents the image to the user.

| field | type | description |
| --- | --- | --- |
| url | string | # A link to the image. |

### Service
... Description of a service.
Each of the service types have the following fields.

| field | type | description |
| --- | --- | --- |
| type | string | The type of the service. |
| title | string | The title of the service, shown in the tab. |

### Terminal service
... What is a terminal service?

| field | type | description |
| --- | --- | --- |
| name | string | The name of the service. |
| port | int | The port of the service. |

### UI service
... What is a UI service?

| field | type | description |
| --- | --- | --- |
| name | string | The name of the service. |
| port | int | The port of the service. |

### Editor service
... What is an editor service?

| field | type | description |
| --- | --- | --- |
| name | string | The name of the service the editor is connected to. |
| port | int | The port of the service. |
| path | string | The path where the file browser of the editor starts out at. |

### External service
... What is an external service?

| field | type | description |
| --- | --- | --- |
| url | string | The url of the website. |





## Challenge scripts
Description...
Describe different challenge setups:
- How to check challenges that use containers?
- How to check challenges that use a cloud provider?

```bash
#!/bin/bash
# setup
echo "Setting up the challenge"
if [ !$EVERYTHING_WENT_WELL ]; then
  exit 1
fi

exit 0
```

```bash
#!/bin/bash
# check
echo "Checking the solution of the challenge"
if [ !$EVERYTHING_WENT_WELL ]; then
  exit 1
fi

exit 0
```

```bash
#!/bin/bash
# solve
echo "Solving the challenge"
```

```bash
#!/bin/bash
# cleanup
echo "Cleaning up after the challenge"
if [ !$EVERYTHING_WENT_WELL ]; then
  exit 1
fi

exit 0
```

## Commit your changes
```bash
git commit -a -m "Initial commit"
[master (root-commit) d745da3] Initial commit
 6 files changed, 54 insertions(+)
 create mode 100755 config.yml
 create mode 100755 first-challenge/check
 create mode 100755 first-challenge/cleanup
 create mode 100755 first-challenge/setup
 create mode 100755 first-challenge/solve
 create mode 100755 track.yml
```

## Import track
When you are happy with your changes, push the changes to the remote git repository. This will import your track into the platform.

```bash
$ git push instruqt
Initialized empty Git repository in /git/repositories/my-first-track.git/
Counting objects: 6, done.
Delta compression using up to 4 threads.
Compressing objects: 100% (5/5), done.
Writing objects: 100% (6/6), 948 bytes | 948.00 KiB/s, done.
Total 6 (delta 0), reused 0 (delta 0)
remote: ==> Importing track
remote: ==> Reading track definition
remote:     OK
remote: ==> Storing track definition
remote:     OK
remote: ==> Reading track configuration
remote:     OK
remote: ==> Generating track configuration code
remote:     OK
remote: ==> Compressing track files
remote:     OK
remote: ==> Uploading track files
remote:     OK
remote: ==> Building track
remote:     Build complete
remote:     OK
To tracks.instruqt.com:my-first-track.git
 * [new branch]      master -> master
```
