Ready OUT-OF-THE-BOX to use packages bundle, with 4 services in docker-compose.yml configuration:
1. freeradius server 3.2.7 as radius server.
2. postgresql 17
3. nodejs backend (akses: http://host-ip:5000) as basic custom UI that can be use as basis of developing.
4. adminer (http://host-ip:8082) as additional general UI that can directly access the database.

Requirement:
1. Internet connection of the mainhost.
2. *nix host environment with sudo or root access. Recommended fedora core os (FCOS).
3. docker and docker-compose installed.
4. bash,,sh not enough because must run a script, you can easily install bash for example if you use alpine linux.
   
Usage :
```bash
# Must run in bash shell because of hostip.sh need it (cant use sh shell).
# Store the directory name in a variable
project_name="radiusapp"
target_dir=$project_name # you can change to any literal string as directory name

# Check if the directory exists, and create it if it doesn't
if [ ! -d "$target_dir" ]; then
    mkdir -p "$target_dir"
    cd "$target_dir" || exit 1
    git clone https://github.com/lfsegoro/"$project_name".git .
else
    cd "$target_dir" || exit 1
    git pull # !!WARNING!! this will overwrite the directory content
fi

# to get the variable needed set
HOST_IP=$(bash ./backend/hostip.sh)
export HOST_IP

# build process
docker-compose build --no-cache
###################################################
# If you already do above you can also run below
# so you dont need to git clone and build again

# optional :
docker rm -f $(docker ps -aq -f status=exited) >/dev/null 2>&1 || true
docker network prune -f >/dev/null 2>&1 || true

docker-compose up
true

```

4. Let the the script do autmatic pull and installing.
5. access from the UI.  http://host-ip:5000 or http://host-ip:8082
6. test using Ntradping or directly from NAS like mikrotik.

You can learn the detail on the docker-compose.yml if you want to see the password or make modification.

The database already have sample username for testing. you can check the radcheck table.

You can test using ntradping or directly from a NAS like mikrotik.

If you need :
- custom freeradius configuration
- more polished UI

Detailed note:
- username and password user testing, 1 entry in 'radcheck' table.
- all host/nas allowed, to see the secret: 1 entry in 'nas' table.
- adminer can have access to all table, make sure choose Postgresql, dbHost ip ADDRESS, username/password you can see in docker-compose.yml
- the only difference with default freeradius config is modified modules only  'sql' inside the /etc/freeradius/mods-enable
- it collude many ports udp and tcp, 1812, 1813, 3799, 5432, 5000, 8082, 8080. if you doing this kind of thing over and over you will learn a lot backend, frontend and tcp/ip etc.
