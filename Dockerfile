#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.


FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build

COPY . .

WORKDIR /jenkinsDemoDotnetProject

RUN dotnet restore

RUN dotnet publish -c Release -o /app

RUN dotnet test --logger "trx;logFileName=./aspnetapp.trx"

FROM mcr.microsoft.com/dotnet/sdk:6.0

COPY --from=build /app .

ENTRYPOINT ["dotnet", "jenkinsDemoDotnetProject.dll"]