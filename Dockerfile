#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.
ARG CLIENTID
ARG CLIENTSECRET
ARG REDIRECTURL
ARG PSQL_HOST
ARG PSQL_USER
ARG PSQL_PASSWORD
ARG PSQL_DATABASE

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["yaflay.ru.csproj", "."]
RUN dotnet restore "./yaflay.ru.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "yaflay.ru.csproj" -c Release -o /app/build 

FROM build AS publish
RUN dotnet publish "yaflay.ru.csproj" -c Release -o /app/publish /p:UseAppHost=false;redirectUrl=$REDIRECTURL;clientId=$CLIENTID;clientSecret=$CLIENTSECRET;Host=$PSQL_HOST;Username=$PSQL_USER;Password=$PSQL_PASSWORD;Database=$PSQL_DATABASE

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "yaflay.ru.dll", "/p:redirectUrl=$REDIRECTURL;clientId=$CLIENTID;clientSecret=$CLIENTSECRET;Host=$PSQL_HOST;Username=$PSQL_USER;Password=$PSQL_PASSWORD;Database=$PSQL_DATABASE"]