---
title: API Reference

# language_tabs: # must be one of https://git.io/vQNgJ
#  - shell

search: true
---

# Introduction
Instruqt is an online learning platform. It teaches you by presenting bite-sized challenges that you need to complete in order to progress. Accompanying these challenges is the explanation of the tools and concepts, needed to complete them.

Through gamification features such as achievements, progression and rankings we try to keep the users engaged.

- ## Assessments
  An organization opens up an assessment track for a specific user, which is invited by email. The assessment consists of any number of challenges and can be kept open for any time period. After the time period ends, a report is generated about the participant. Showing which challenges were played, how long it took to complete them and where the participant got stuck during the completion of the challenges.

- ## Competition events
  Organizations can create public and invite-only events where participants compete in challenges and are ranked.

- ## Learning paths
  Users select topics and technologies they use / want to learn and we generate personalized learning paths for the user by dynamically combining tracks. From whatever starting point, the user gets offered a smooth learning path towards his/her goal.

- ## SDK
  Not only instruqt employees can create content for instruqt. With the SDK anyone can create private or public challenges and tracks.

- ## Performance statistics
  We can offer details statistics about the performance of a user, team or organization.

# SDK
Intro...

## Authenticating
```bash
$ instruqt auth login
Enter your instruqt credentials.
Email: example@instruqt.com
Password:

... Authenticating
... Generating keys
... Uploading public key
```

## Create track
To create a new track you can use the instruqt CLI tool, which is included in the SDK.

```bash
$ instruqt track create example-track

... Creating track files
... Creating remote repository
... Configuring credentials
... Configuring hooks
... Setting git remote
```
The `track create` command creates the track/track.yml and track/config.yml files with skeleton content.
Remotely it creates a git repository with credentials and hooks already set up. Once the process completes, it outputs the remote git repository that stores and builds the track.

## Track content
After the track is created, fill out the track.yml and config.yml files with the needed information.

```yaml
# track.yml
slug: example-track
icon: https://instruqt.com/image.png
credits: 1
tags:
  - example
title: Example track
teaser: Teasing the example track.
description: |
  A full description of the track, shown in the track details.
  The description is written in markdown.
challenges: []
```

### Track
... Describe the track object.

| field | type | description |
| --- | --- | --- |
| **slug** | string | A string that is the ID of the track. The value of the ID should be globally unique. |
| **icon** | string | The URL of the icon that is to be shown with the track. The size of the icon should be ??x??. |
| **tags** | list | A list of strings that represent tags associated with the track. |
| **title** | string | The title of the track. |
| **teaser** | string | A short description of the track, which is shown in the track list. |
| **description** | string | A full description of the track, which is shown at the track details. |
| **challenges** | list | A list of challenges that belong to the track. |

### Configuration
... Describe the configuration   
... What is the configuration for?   
... What happens with the configuration?   

```yaml
# config.yml
template: containers
configuration:
  containers:
    - name: example
      image: gcr.io/instruqt/example:latest
      ports:
        - name: http
          port: 80
          exposed: true
      resources:
        memory: 128
```

| field | type | description |
| --- | --- | --- |
| **template** | string | The template that will be used to create the user environment. Other options include gcloud, aws and azure. |
| **configuration** | object | The configuration of the template. |

### Templates
... Which templates are there?   
... What do they do?   

### Containers
... Configuration for containers template   

| field | type | description |
| --- | --- | --- |
| **containers** | list | A list of containers that should be started in the user environment. |

### Container
... Describe the container object.

| field | type | description |
| --- | --- | --- |
| **name** | string | The name the container will be reachable as. |
| **image** | string | The docker image to use for the container. |
| **ports** | list | A list of ports to expose. |
| **resources** | object | Optional, will default to 128MB Memory. The resources the container needs to run. |

### Ports
... Describe the ports list.

| field | type | description |
| --- | --- | --- |
| **name** | string | The name of the port. |
| **port** | int | The port that needs to be exposed on the inside. |
| **exposed** | bool | Wether or not the container should be reachable from the user's browser. |

### Resources
... Describe the resources.

| field | type | description |
| --- | --- | --- |
| **memory** | int | The memory the container needs in MB. |

## Create challenge
Now that the track information and environment configuration are set up, start creating challenges.

```bash
$ instruqt challenge create first-challenge

... output
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
    title: The first challenge
    teaser: Teasing the first challenge
    difficulty: basic
    timelimit: 900
    unlocks:
      - second-challenge
    notes:
      - type: text
        title: The first note
        contents: |
          This is the first note, written in markdown.
          It supports all the common markdown elements.
          Check https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet for more information.

      - type: video
        title: A youtube video
        url: https://www.youtube.com/embed/video

      - type: image
        title: An image
        url: http://instruqt.com/image.png
    assignment: |
      The action the user needs to perform.
      The assignment is written in markdown.
    services:
      - type: terminal
        title: Bash
        name: shell
        port: 8080

      - type: ui
        title: Nginx
        name: nginx
        port: 3000

      - type: editor
        title: Editor
        name: shell
        path: /home/user/code

      - type: external
        title: Example.org
        url: https://www.example.org
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

## Validate track
To check if the track.yml and config.yml are correct, run the `track validate` command.

```
$ instruqt track validate

... output
```

The validate command checks the structure and contents of the track/track.yml file for validity. It also checks if the unlock sequence is correct and all listed challenges have their scripts directory.

The track/config.yml is also checked, to ensure that all the configuration needed for the given template is present and valid.

## Import track
When you are happy with your changes, push the changes to the remote git repository. This will import your track into the platform.

```
$ git push instruqt master

... Importing track
... Generating environment
... Packaging track
... DONE
```

## Local setup?
- start minikube
- create track and user namespaces
- launch local track into track namespace
- launch containers into user namespace

```bash
# Create the user environment.
$ instruqt track setup

# Setup the challenge.
$ instruqt challenge setup first-challenge

# Check the challenge solution.
$ instruqt challenge check first-challenge

# Enter the correct solution.
$ instruqt challenge solve first-challenge

# Cleanup the challenge.
$ instruqt challenge cleanup first-challenge

# Destroy the user environment.
$ instruqt track cleanup
```

# Sales

## Rabobank
- feedback on proposal

## Bol.com
- plan meeting mid august

## NS
- arrange payment for hackathons
- prepare hackathon at NS with management
- prepare hackathon at NS internal event

## KPN
- plan meeting

## CRI
- meeting 26 July

## Fujitsu
- meeting 21 July

## Atos
- plan meeting mid august

## Portbase
- plan meeting mid august

## Quby
- plan meeting when closing down play.instruqt.com

## Marktplaats
- contact about new pricing model

# Infrastructure
- own gitlab instance `NICE TO HAVE`
- bootstrap project
- core GKE cluster
- core namespaces
- core build pipeline
- remove need for lego `NEEDED?`
  ```
  specific certificates:

  service-participant.env.instruqt.com
  service-participant.organization.env.instruqt.com
  ```

# Track build pipeline
- instruqt cli
- create track repository
- add credentials to the repository
- add post-receive hook to the repository
- copy in the Dockerfile
- compress track sources
- copy the compressed track to bucket
- send the build.yml to container builder
- generate the terraform code
- build the docker image

# Backend
- check calls to track
- setup calls to track
- cleanup calls to track

# Frontend
- design style guide `BLOCKER`
- create basic layouts `BLOCKER`
- create presentational components
- create container components
- design redux state
- create redux reducers
- create redux actions
- create redux selectors
- create redux middleware
