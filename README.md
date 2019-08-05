# Stream Test iOS

A native iOS app (swift) that plays audio from a stream and shows the associated metadata


## Requirements

1. Read the JSON endpoint and display the latest song title and artist
2. Playback the stream's audio
3. Update the displayed data whenever metadata in the stream changes
4. Synchronize the metadata and audio with airplay, a bluetooth device or an Apple TV
5. Optional: Display the song's cover by accessing the itunesCoverMedium parameter from the JSON


## Pods Used

- Alamofire
- SwiftyJSON*

* By default it targets Swift 5.0, and this needs to be fixed in the Build Settings (Swift Language Version) before compiling the project.
