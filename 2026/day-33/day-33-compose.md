# Day 33 – Docker Compose: Multi-Container Basics

## Challenge Tasks

### Task 1: Install & Verify

Docker Compose lets you define and run multi-container applications from one YAML file, using one command. Instead of typing long docker run commands for each container, you describe everything once in docker-compose.yml and start it all with docker compose up.

The problem it solves

Most real applications need several parts working together, such as a web app, a database and a cache. Without Compose
1. Check if Docker Compose is available on your machine
2. Verify the version

    ![image](images/compose-version.png)

---

### Task 2: Your First Compose File
1. Create a folder `compose-basics`
2. Write a `docker-compose.yml` that runs a single **Nginx** container with port mapping
3. Start it with `docker compose up`
4. Access it in your browser
5. Stop it with `docker compose down`

  

    [Compose file](compose-basics/docker-compose.yml)
    
    ![image](images/nginx.png)

    ![image](images/compose.png)
    ![image](images/compose-down.png)

---

### Task 3: Two-Container Setup
Write a `docker-compose.yml` that runs:
- A **WordPress** container
- A **MySQL** container

They should:
- Be on the same network (Compose does this automatically)
- MySQL should have a named volume for data persistence
- WordPress should connect to MySQL using the service name

Start it, access WordPress in your browser, and set it up.

![image](images/w1.png)


![image](images/w2.png)


**Verify:** Stop and restart with `docker compose down` and `docker compose up` — is your WordPress data still there?

- Yes,wordpress data is there.


![image](images/w3.png)


![image](images/w4.png)



[Compose file](wordpress-mysql/docker-compose.yml)
    

---

### Task 4: Compose Commands
Practice and document these:
1. Start services in **detached mode**

    `docker compose up -d`
    ![image](images/d1.png)

2. View running services

    `docker compose ps`
    ![image](images/d2.png)

3. View **logs** of all services

    `docker compose logs db` && `docker compose logs wordpress`
    ![image](images/d3.png)

4. View logs of a **specific** service

    ![image](images/d4.png)

5. **Stop** services without removing

    `docker compose stop`
    ![image](images/d5.png)

6. **Remove** everything (containers, networks)

    `docker compose down`
    ![image](images/d6.png)

7. **Rebuild** images if you make a change

    `docker compose up --build.`
     ![image](images/d7.png)

---

### Task 5: Environment Variables
1. Add environment variables directly in your `docker-compose.yml`
2. Create a `.env` file and reference variables from it in your compose file
3. Verify the variables are being picked up

    ![image](images/t5.png)

    [Compose file](worpress-mysql-env/docker-compose.yml)

    [Env](worpress-mysql-env/.env)
        