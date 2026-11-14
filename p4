/*
 * Practical 4: UDP Echo Server (Connectionless Datagram Communication)
 * --------------------------------------------------------------------
 * Description:
 *   Creates a UDP socket, binds to port 10011, waits for a message from a client, prints the received message,
 *   and sends the echo back to the client.
 *
 * Requirements:
 *   Linux / WSL terminal (uses POSIX socket headers: <arpa/inet.h>, <unistd.h>)
 *
 * How to Run:
 *   1. Compile server:
 *      gcc -x c p4 -o p4
 *      (or if renamed with .c: gcc p4.c -o p4)
 *
 *   2. Run the UDP server first (Terminal 1):
 *      ./p4
 *
 *   3. In another terminal (Terminal 2), run the UDP client:
 *      ./p5
 */

#include <arpa/inet.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>

#define PORT 10011

int main() {
    int sockfd;
    char buffer[1024];

    struct sockaddr_in server_addr, client_addr;
    socklen_t len = sizeof(client_addr);

    sockfd = socket(AF_INET, SOCK_DGRAM, 0);

    if (sockfd < 0) {
        printf("Socket creation failed\n");
        return -1;
    }

    server_addr.sin_family = AF_INET;
    server_addr.sin_addr.s_addr = INADDR_ANY;
    server_addr.sin_port = htons(PORT);

    if (bind(sockfd, (struct sockaddr *)&server_addr,
             sizeof(server_addr)) < 0) {
        printf("Bind failed\n");
        return -1;
    }

    printf("UDP Echo Server waiting...\n");

    recvfrom(sockfd, buffer, sizeof(buffer), 0,
             (struct sockaddr *)&client_addr, &len);

    printf("Message from client: %s\n", buffer);

    sendto(sockfd, buffer, strlen(buffer) + 1, 0,
           (struct sockaddr *)&client_addr, len);

    printf("Echo message sent to client\n");

    close(sockfd);

    return 0;
}
