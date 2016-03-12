# Zope2 in a Docker Container

Use `docker pull ulrichschreiner/zope2` to get the latest version from the dockerhub. You also can use the tags as image tags.

# Run

Start the container without a `--user`. Instead you must mount the `/zope`
volume. The container will create a user which will write with the correct
`uid` and `gid`. Do not start the container without a hostmounted `/zope`
directory.

# Datacontainers

Not supported. I use this container for a legacy project and it is not
planned to support it more than needed.
