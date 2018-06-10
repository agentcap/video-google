# video-google
A Text Retrieval Approach to Object Matching in Videos using SIFT features and 'ti-idf' for ranking the results.

# Requirement
VLFEAT library
ffmpeg

# Instructions
- Use `ffmpeg -i video.mp4 -vf select='gt(scene\,0.4)' -vsync vfr frame/frames%d.png` to split the video into frames by sampling from each shot.
- Create index by giving the name of the frames directory as input tp 'create_idx' function.
- To search for top 10 matches in the frames give the name of the image as input to 'google_img'
