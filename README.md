# docker 
======================

To build an image with docker

    docker build -t newimage .

Then to run that image and attach to it at the same time:

    docker run -i -t newimage
    
Or to run it in the background
  
    docker run -d -p 27017:27017 -p 8080:8080 -p 6379:6379 newimage
