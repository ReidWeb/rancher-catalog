# Atlassian Crowd

## Installation

1. Execute 
    ```bash
    docker exec -it crowd-db psql -U postgres
    ```
    Followed by:
    ```sql
    CREATE DATABASE crowd;
    \l
    \q
    ```
1. Navigate to `http://yourcrowd.example.com/console`.
1. Enter your license key