#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:3.1 AS build
WORKDIR /src
COPY ["JenkinsCICDTest/JenkinsCICDTest.csproj", "JenkinsCICDTest/"]
RUN dotnet restore "JenkinsCICDTest/JenkinsCICDTest.csproj"
COPY . .
WORKDIR "/src/JenkinsCICDTest"
RUN dotnet build "JenkinsCICDTest.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "JenkinsCICDTest.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "JenkinsCICDTest.dll"]