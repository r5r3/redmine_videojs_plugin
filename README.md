# Redmine Video.js plugin
Redmine Plugin to embed Video.js

This plugin provides an additional wiki macro for Redmine, which allows to embed video files using the Video.js player.

Compatibility: Tested with Redmine 3.2.0

## Installation
Go to the plugin folder of your redmine installation and clone this repository:

    git clone https://github.com/r5r3/redmine_videojs_plugin

Migrate:

     rake redmine:plugins:migrate RAILS_ENV=production

And finally restart Redmine.

## Usage

Currently the video type is hardcoded to mp4, that means you have to use mp4 videos.

For attached videos in wiki pages write:

    {{video(filename.mp4)}}

The default size of the video is set to ```auto```, i.e., the native size of the video. To specify the size write:

    {{video(filename.mp4,WIDTH,HEIGHT)}}

```WIDTH``` and ```HEIGHT``` are both allowed to take the value ```auto```. In this case the aspect ratio is conserved. 
