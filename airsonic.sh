#!/bin/bash
set -e

# TODO: can use same database for different VM instance? (so don't need re-scan media)
# TODO: rclone read-only mode

# Pre-setup:
# Config rclone
# Mount

if [ -f "/tmp/airsonic.war" ]; then
  echo "war file exists."
else
  sudo apt-get install -y ffmpeg lame openssl ca-certificates openjdk-11-jre
  gpg --keyserver keyserver.ubuntu.com --recv 0A3F5E91F8364EDF
  wget https://github.com/airsonic/airsonic/releases/download/v10.6.2/airsonic.war --output-document=/tmp/airsonic.war
fi

AIRSONIC_DIR=$HOME/airsonic
MUSIC_DIR=$HOME/music
mkdir -p $AIRSONIC_DIR/data
mkdir -p $AIRSONIC_DIR/music
mkdir -p $AIRSONIC_DIR/podcasts
mkdir -p $AIRSONIC_DIR/playlists
mkdir -p $AIRSONIC_DIR/data/transcode
ln -fs /usr/bin/ffmpeg $AIRSONIC_DIR/data/transcode/ffmpeg
ln -fs /usr/bin/lame $AIRSONIC_DIR/data/transcode/lame

java \
  -Dserver.host=0.0.0.0 \
  -Dserver.port=8080 \
  -Dairsonic.home=$AIRSONIC_DIR/data \
  -Dairsonic.defaultMusicFolder=$MUSIC_DIR \
  -Dairsonic.defaultPodcastFolder=$AIRSONIC_DIR/podcasts \
  -Dairsonic.defaultPodcastFolder=$AIRSONIC_DIR/podcasts \
  -Dairsonic.defaultPlaylistFolder=$AIRSONIC_DIR/playlists \
  -jar /tmp/airsonic.war

# Post-setup:
# Change admin password
# Enable Fast access mode
# Disable transcoder
