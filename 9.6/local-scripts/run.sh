#!/bin/sh

USER_INPUT="$1"

up() {
    echo "========= Starting The App Environment ========="
    docker-compose -f ../docker-compose.yml up -d && \
    docker exec -it app /bin/sh -c "composer install" || true && \
    echo "========= The App Environment is Ready ========="
}

down() {
    echo "========= Stopping The App Deployment Environment ========="
    docker-compose -f ../docker-compose.yml down
    echo "========= The App Deployment Environment is Down ========="
}

build() {
    echo "========= Building the Docker Image =========" && \
    docker build -t app:local ../ -f ../Dockerfile && \
    echo "========= App Image Build Complete ========="
}

rebuild() {
    echo "========= Rebuilding the Local App Development Image =========" && \
    docker build -t app:local ../ -f ../Dockerfile && \
    docker-compose -f ../docker-compose.yml restart app && \
    echo "========= App reBuild Complete ========="
}

test() {
    echo "========= Starting Tests ========="
    docker exec -it app /bin/sh -c "vendor/bin/phpunit --stop-on-failure"
    echo "========= Testing Complete ========="
}

clean() {
    echo "========= Starting CleanUp ========="
    docker-compose -f ../docker-compose.yml down && \
    docker-compose -f ../docker-compose.yml down && \
    echo "========= Removing Local App Development Image =========" && \
    docker rmi -f app:local && \
    echo "========= Removing the laravel/vendor directory =========" && \
    rm -Rf ../laravel/vendor && \
    echo "========= Removing node_modules directory =========" && \
    rm -Rf ../laravel/node_modules && \
    echo "========= Removing bootstrap/cache files =========" && \
    rm -Rf ../laravel/bootstrap/cache/packages.php && \
    rm -Rf ../laravel/bootstrap/cache/services.php && \
    echo "========= Removing Volumes =========" && \
    docker volume prune -f && \
    echo "========= CleanUp Completed =========" && \
    echo "========= CleanUp Docker System =========" &&
    docker system prune -f && \
    echo "========= Docker System Cleaned ========="
}

mseed(){
    docker exec -it app /bin/sh -c "php artisan migrate --seed"
}

seed(){
    docker exec -it app /bin/sh -c "php artisan db:seed"
}

sshApp() {
    echo "========= Accessing The App CLI ========="
    docker exec -it app /bin/sh
}

tail(){
    echo "========= Following Logs ========="
    docker-compose -f ../docker-compose.yml logs -f
}

help(){
echo "
usage: ./run.sh [parameter] 

  parameter:
      up           :starts all containers in the docker-compose.yml file.
      down         :stops all containers in the docker-compose.yml file.
      build        :build the app development image.
      rebuild      :rebuilds the app development image and restarts the app.
      test         :runs the app tests.
      clean        :stops all containers, removes temporary files, and the vendor directory.
      mseed        :run the app migrations, and seed the database.
      seed         :seed the database.
      ssh-app      :ssh into app container.
      tail         :follows all container logs | equivalant to 'docker-compose logs -f'.
      help         :displays this menu.

  "
}


case "${USER_INPUT}" in
  "up")
    up
    ;;
  "down")
    down
    ;;
  "build")
    build
    ;;
  "rebuild")
    rebuild
    ;;
  "test")
    test
    ;;
  "clean")
    clean
    ;;
  "mseed")
    mseed
    ;;
  "seed")
    seed
    ;;
  "ssh-app")
    sshApp
    ;;
  "tail")
    tail
    ;;
  "help")
    help
    ;;
esac
