# BitBucket Server
## Installation

1. Execute 
    ```bash
    docker exec -it bitbucket-db psql -U postgres
    ```
    Followed by:
    ```sql
    CREATE DATABASE bitbucket;
    \l
    \q
    ```
1. Navigate to `http://bitbucket.example.com/console`.
1. Continue config