#!/bin/bash
set -e

# NOTE: rclone cmd
# fusermount -u $HOME/gdrive_music
# rclone copy gdrive:airsonic/data.tar.gz /tmp

# Same database can be used for different VM instance (i.e. don't need re-scan media)
# Better security: rclone read-only mode

MUSIC_DIR=$HOME/gdrive_music
AIRSONIC_DIR=$HOME/airsonic

# Pre-setup:
#rclone config
#mkdir -p $MUSIC_DIR
#rclone mount --daemon gdrive:airsonic/music $MUSIC_DIR
# (optional) Recover airsonic settings

if [ -f "$AIRSONIC_DIR/airsonic.war" ]; then
  echo "war file exists."
else
  sudo apt-get install -y ffmpeg lame openssl ca-certificates openjdk-11-jre
  gpg --keyserver keyserver.ubuntu.com --recv 0A3F5E91F8364EDF
  wget https://github.com/airsonic/airsonic/releases/download/v10.6.2/airsonic.war --output-document=$AIRSONIC_DIR/airsonic.war
fi

mkdir -p $AIRSONIC_DIR/data
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
  -jar $AIRSONIC_DIR/airsonic.war

# Post-setup:
# Change admin password
# Enable Fast access mode
# Disable transcoder
