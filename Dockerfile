# Use .NET SDK for building
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy csproj and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o /app/publish --no-restore

# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app/publish .

# Create wwwroot directory if it doesn't exist
RUN mkdir -p /app/wwwroot

# Expose port (adjust if your app uses a different port)
EXPOSE 80
EXPOSE 443

# Set entry point
ENTRYPOINT ["dotnet", "SimpleAzureWebApp.dll"] 