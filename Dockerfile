#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 7000
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["TmminAuth.csproj", "."]
RUN dotnet restore "./TmminAuth.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "./TmminAuth.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./TmminAuth.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "TmminAuth.dll"]