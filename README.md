
This script works similar to git modules.
It can recursively checkout dependent repositories.

If `foo` repo needs `bar` repo at commit `123456`, `some.replink` config in `foo` repo contains line:
```
C4REL bar/other.replink https://github.com/group/bar.git 123456
```

`bar` directory can be checkout into `foo` directory or near it using `../bar/other.replink`.

With linux and git installed it could be run just like this:
```
C4REPO_MAIN_CONF=/some_path/some_repo/example.replink ./replink.pl
```

Or it can be used in docker:
```
### docker-compose.yml
version: '3.2'
services:
  main:
    command: ["/replink.pl"]
    image: c4replink:v2
    volumes:
    - ${HOME}/c4agent.ssh:/c4/.ssh
    - ${HOME}/c4repo:/c4/c4repo
    environment:
    - C4REPO_MAIN_CONF=/c4/c4repo/c4dep.main.replink
### run
./build && mkdir -p $HOME/c4repo && docker-compose up

```
