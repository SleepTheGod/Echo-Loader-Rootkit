#!/bin/sh

# Educational Simple Echo Server Script by Taylor Christian Newsome

echo "Starting the educational simple echo server setup..."

# Include necessary header files for socket programming
cat << EOF > /tmp/simple_echo_server.c
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <netinet/in.h>

void die(const char *message) {
    perror(message);
    exit(1);
}

int main() {
    int sockfd, newsockfd, portno = 9050;
    socklen_t clilen;
    char buffer[256];
    struct sockaddr_in serv_addr, cli_addr;
    int n;

    sockfd = socket(AF_INET, SOCK_STREAM, 0);
    if (sockfd < 0) 
        die("ERROR opening socket");

    bzero((char *) &serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    serv_addr.sin_addr.s_addr = INADDR_ANY;
    serv_addr.sin_port = htons(portno);

    if (bind(sockfd, (struct sockaddr *) &serv_addr, sizeof(serv_addr)) < 0) 
        die("ERROR on binding");

    listen(sockfd, 5);
    clilen = sizeof(cli_addr);
    newsockfd = accept(sockfd, (struct sockaddr *) &cli_addr, &clilen);
    if (newsockfd < 0) 
        die("ERROR on accept");

    bzero(buffer,256);
    n = read(newsockfd, buffer, 255);
    if (n < 0) die("ERROR reading from socket");
    printf("Here is the message: %s\n", buffer);

    n = write(newsockfd, "I got your message", 18);
    if (n < 0) die("ERROR writing to socket");

    close(newsockfd);
    close(sockfd);
    return 0;
}
EOF

# Compile the server code
gcc -o /bin/simple_echo_server /tmp/simple_echo_server.c
rm -f /tmp/simple_echo_server.c

# Instruction to run the server
echo "To run the simple echo server, execute /bin/simple_echo_server"
echo "Server will listen on port 9050"

exit 0
