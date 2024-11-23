#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 5008

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



#--------------------------CONFIG DOCKER--------------------------------#
#FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS build
#WORKDIR /app
#
#COPY ["TmminAuth.csproj", "."]
#RUN dotnet restore "./TmminAuth.csproj"
#
#COPY . .
#
#RUN dotnet publish -c Release -o out
#
#FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS runtime
#WORKDIR /app
#COPY --from=build /app/out ./
#
#EXPOSE 4000
#
#ENTRYPOINT ["dotnet", "TmminAuth.dll"]