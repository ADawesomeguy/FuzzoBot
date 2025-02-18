﻿FROM mcr.microsoft.com/dotnet/runtime:6.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["FuzzoBot/FuzzoBot.csproj", "FuzzoBot/"]
COPY ["RedDatabase/RedDatabase.csproj", "RedDatabase/"]
RUN dotnet restore "FuzzoBot/FuzzoBot.csproj"
COPY . .
WORKDIR "/src/FuzzoBot"
RUN dotnet build "FuzzoBot.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "FuzzoBot.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "FuzzoBot.dll"]
