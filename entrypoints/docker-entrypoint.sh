#!/bin/sh
set -e

if [ -f tmp/pids/server.pid ]; then
  rm tmp/pids/server.pid
fi

echo "Starting App..."
bundle exec rails db:setup
bundle exec rails db:migrate

echo "Starting App..."

# Lancement de la compilation des fichiers CSS avec Tailwind en arrière-plan
bin/rails tailwindcss:watch &

# Lancement de la compilation des fichiers JavaScript en arrière-plan
npm run build -- --watch &

# Démarrage du serveur Rails
bundle exec rails s -b 0.0.0.0
