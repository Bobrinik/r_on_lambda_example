## Troubleshooting
```text
{
  "errorType": "Runtime.InvalidEntrypoint",
  "errorMessage": "RequestId: 81c60be4-633c-4eb0-a9ce-6814bf1d9809 Error: fork/exec /lambda-entrypoint.sh: exec format error"
}
```
- To resolve this use `platform: "linux/amd64"`

### Something else is failing?
- Debug lambda from local:
1. Run lambda locally
```bash
docker run -d -p 9000:8080 --entrypoint /usr/local/bin/aws-lambda-rie   image_uri:tagOrDigest
```
2. Find Docker container
```bash
docker ps

# You will see something like this 
CONTAINER ID   IMAGE          COMMAND                  CREATED         STATUS         PORTS                    NAMES
5736c1546e60   d8ec635e49c5   "/usr/local/bin/aws-…"   9 minutes ago   Up 9 minutes   0.0.0.0:9000->8080/tcp   dreamy_thompson

```
3. Follow container logs
```bash
docker logs -f 5736c1546e60
```

4. Open another terminal and run
```bash
url -X POST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{"test":"here"}'
```
5. See what's happening with the logs