---
title: API Reference

language_tabs: # must be one of https://git.io/vQNgJ
  - shell
  - go
  - javascript

search: true
---

# Introduction
Instruqt is an online learning platform. It teaches you by presenting bite-sized challenges that you need to complete in order to progress. Accompanying these challenges is the explanation of the tools and concepts, needed to complete them.

Through gamification features such as achievements, progression and rankings we try to keep the users engaged.

- #### Assessments
  An organization opens up an assessment track for a specific user, which is invited by email. The assessment consists of any number of challenges and can be kept open for any time period. After the time period ends, a report is generated about the participant. Showing which challenges were played, how long it took to complete them and where the participant got stuck during the completion of the challenges.

- #### Competition events
  Organizations can create public and invite-only events where participants compete in challenges and are ranked.

- #### Learning paths
  Users select topics and technologies they use / want to learn and we generate personalized learning paths for the user by dynamically combining tracks. From whatever starting point, the user gets offered a smooth learning path towards his/her goal.

- #### SDK
  Not only instruqt employees can create content for instruqt. With the SDK anyone can create private or public challenges and tracks.

- #### Performance statistics
  We can offer details statistics about the performance of a user, team or organization.

---

# SDK
Intro...

#### Authenticating
```
$ intruqt login
Enter your instruqt credentials.
Email: example@instruqt.com
Password:
Uploading ssh public key /Users/example/.ssh/id_rsa.pub
```

#### Create track
To create a new track you can use the instruqt CLI tool, which is included in the SDK.

```bash
$ instruqt track create example-track

... output
```
The `track create` command creates the track/track.yml and track/config.yml files with skeleton content.
Remotely it creates a git repository with credentials and hooks already set up. Once the process completes, it outputs the remote git repository that stores and builds the track.

Set the remote git repository to the given remote.

```bash
$ git remote add origin git://instruqt.io/example/example-track
```

#### Track content
After the track is created, fill out the track.yml and config.yml files with the needed information.

```yaml
# track.yml
# The unique ID of the track.
slug: example-track
# The icon to show with the track.
icon: https://instruqt.com/image.png
# The price of the track.
credits: 1
# Tags associated with the track.
tags:
  - example
# The title of the track.
title: Example track
# A short description of the track, shown in the track list.
teaser: Teasing the example track.
# A full description of the track, shown in the track details.
description: |
  A full description of the track, shown in the track details.
  The description is written in markdown.
# A list of challenges that belong to the track.
challenges: []
```

```yaml
# config.yml
# Other options include gcloud, aws and azure.
template: containers
# The configuration of the template.
configuration:
  # A list of containers that should be started in the user environment.
  containers:
      # Example container exposed as example-80.hash.env.instruqt.com.
      # The name the container will be reachable as.
    - name: example
      # The docker image to use for the container.
      image: gcr.io/instruqt/example:latest
      # A list of ports to expose.
      ports:
          # The name of the port.
        - name: http
          # The port that needs to be exposed on the inside.
          port: 80
          # Wether or not the container should be reachable from the user's browser.
          exposed: true
      # Optional, will default to 128MB Memory.
      # The resources the container needs to run.
      resources:
        # The memory the container needs in MB.
        memory: 128
```

#### Create challenge
Now that the track information and environment configuration are set up, start creating challenges.

```bash
$ instruqt challenge create first-challenge

... output
```

The `challenge create` command creates a new directory inside the track directory, named after the challenge. This directory includes the lifecycle scripts that control the challenge.

| script | stage | description |
| --- | --- | --- |
| `setup` | Starting challenge | Prepare the challenge for the user |
| `check` | Checking challenge | Check the user solution for the challenge |
| `solve` | Testing challenge | Programmatically solve the challenge |
| `cleanup` | Completing challenge | Cleanup the environment after challenge |

The command also creates a challenge entry in the track/track.yml file, to put the details of the challenge.

```yaml
# track.yml
challenges:
    # A unique ID within the scope of the track.
  - slug: first-challenge
    # The title of the challenge.
    title: The first challenge
    # A short description of the challenge, shown in the challenge list.
    teaser: Teasing the first challenge
    # The difficulty of the track.
    # Can be any of basic, intermediate, advanced and expert.
    difficulty: basic
    # The time in seconds before a challenge is automatically failed and stopped.
    timelimit: 900
    # The list of challenges that are unlocked upon completing the challenge.
    unlocks:
      - second-challenge
    # A list of notes that provide the user with context and background information.
    # Notes can be a of the type text, video or image.
    notes:
        # A text note presents a piece of markdown to the user.
      - type: text
        # The title of the note.
        title: The first note
        # The contents of the note.
        contents: |
          This is the first note, written in markdown.
          It supports all the common markdown elements.
          Check https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet for more information.

        # A video note presents a video player to the user.
      - type: video
        # The title of the video.
        title: A youtube video
        # A embed link to the video.
        url: https://www.youtube.com/embed/video

        # An image note presents the image to the user.
      - type: image
        # The title of the image.
        title: An image
        # A link to the image.
        url: http://instruqt.com/image.png
    # A description of the actual challenge the user needs to complete.
    assignment: |
      The action the user needs to perform.
      The assignment is written in markdown.
    # A list of services that are exposed to the user in the browser.
    services:
        # The type of service.
        # Can be any of the following: terminal, editor or website.
        # A terminal service shows a shell in the browser.
      - type: internal
        # The icon to use for the service.
        # Can be terminal or ui.
        icon: terminal
        # The title of the terminal, shown in the service tab.
        title: Bash
        # The name of the service.
        name: shell
        # The port of the service.
        port: 8080

        # An editor service shows a code editor in the browser.
      - type: editor
        # The title of the editor, shown in the service tab.
        title: Editor
        # The name of the service the editor is connected to.
        name: shell
        # The path the editor starts at.
        path: /home/user/code

        # An external service shows the website in the browser.
      - type: external
        # The title of the website, shown in the service tab.
        title: Example.org
        # The url of the website.
        url: https://www.example.org
```

#### Challenge scripts
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

#### Validate track
To check if the track.yml and config.yml are correct, run the `track validate` command.

```
$ instruqt track validate

... output
```

The validate command checks the structure and contents of the track/track.yml file for validity. It also checks if the unlock sequence is correct and all listed challenges have their scripts directory.

The track/config.yml is also checked, to ensure that all the configuration needed for the given template is present and valid.

#### Import track
When you are happy with your changes, push the changes to the remote git repository. This will import your track into the platform.

```
$ git push -u origin master

... Importing track
... Generating environment
... Packaging track
... DONE
```

#### Local setup?
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

---

# Sales

#### Rabobank
- feedback on proposal

#### Bol.com
- plan meeting mid august

#### NS
- arrange payment for hackathons
- prepare hackathon at NS with management
- prepare hackathon at NS internal event

#### KPN
- plan meeting

#### CRI
- meeting 26 July

#### Fujitsu
- meeting 21 July

#### Atos
- plan meeting mid august

#### Portbase
- plan meeting mid august

#### Quby
- plan meeting when closing down play.instruqt.com

#### Marktplaats
- contact about new pricing model

---

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

---

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

---

# Backend
- check calls to track
- setup calls to track
- cleanup calls to track

---

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
