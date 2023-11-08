# utilise l image comme environnement de construction.
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-env
#Définit un répertoire de travail /App.
WORKDIR /App
# Copie tous les fichiers du répertoire local actuel dans le répertoire de travail de l'image.
COPY . ./
# pour restaurer les dépendances du projet
RUN dotnet restore
# pour construire le projet en mode Release (compilée avec des optimisations de performances) et le publier dans le dossier out.
RUN dotnet publish -c Release -o out

# Build runtime image
# utilise l image comme image de l'environnement d'exécution.
FROM mcr.microsoft.com/dotnet/aspnet:7.0
#Copie les fichiers de sortie de la première étape (build-env) depuis le répertoire /App/out vers le répertoire de travail actuel (/App) de l'image.
WORKDIR /App
COPY --from=build-env /App/out .
#Cela indique à Docker comment démarrer l'application au lancement du conteneur.
ENTRYPOINT ["dotnet", "DotNet.Docker.dll"]