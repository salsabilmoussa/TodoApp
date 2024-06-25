# Utiliser une image Dart officielle avec la version 3.4.3
FROM dart:3.4.3

# Installer des dépendances requises pour Flutter
RUN apt-get update && apt-get install -y git curl unzip xz-utils

# Installer Flutter
RUN git clone https://github.com/flutter/flutter.git -b stable --depth 1 /flutter

# Ajouter Flutter au PATH
ENV PATH="/flutter/bin:/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Mettre à jour Flutter et configurer Flutter doctor
RUN flutter doctor

# Configurer git pour permettre l'utilisation de Flutter comme un répertoire sûr
RUN git config --global --add safe.directory /flutter

# Créer et utiliser un utilisateur non-root
RUN useradd -ms /bin/bash flutteruser

# Changer les permissions du répertoire Flutter pour l'utilisateur non-root
RUN chown -R flutteruser:flutteruser /flutter

# Passer à l'utilisateur non-root
USER flutteruser

# Définir le répertoire de travail
WORKDIR /home/flutteruser/app/frontend

# Copier les fichiers du projet et définir les permissions
COPY --chown=flutteruser:flutteruser . .

# Installer les dépendances Flutter
RUN flutter pub get

# Exposer le port pour le serveur web
EXPOSE 5000

# Démarrer l'application Flutter pour le web
CMD ["flutter", "run", "-d", "web-server", "--web-port", "5000", "--web-hostname", "0.0.0.0"]
