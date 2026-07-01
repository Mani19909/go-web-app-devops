# Containerize the go application that we have created
# This is the Dockerfile that we will use to build the image
# and run the container

# Start with base image
FROM golang:1.21 as base

# Set the workdir directory inside the container
WORKDIR /app

# Copy the go.mod and go.sum files to the working directory
COPY go.mod ./

# Download all Dependencies
RUN go mod download

# Copy the source code to the working directory
COPY . .

# Build application
RUN go build -o main .

################################################
# Reduce the image size using multi-stage builds
# we will use a distroless image to run the application
FROM gcr.io/distroless/base

# Copy the binary from the previous stage
COPY --from=base /app/main .

# Copy the static files from the prious stage
COPY --from=base /app/static ./static

# Expose the port on which the application will run 
EXPOSE 8080

# Command to run the application
CMD ["./main"]