```
docker run -ti -v $(pwd)/source:/slate/source -v $(pwd)/build:/slate/build slate && \
docker build -t instruqt.com/docs . && \
docker run -ti -p 9999:80 instruqt.com/docs
```
