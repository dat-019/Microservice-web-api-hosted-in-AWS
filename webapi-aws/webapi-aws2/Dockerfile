FROM microsoft/dotnet:2.1-sdk AS build-env

# Copy everything else and build
COPY . /app2
WORKDIR /app2

# RUN dotnet restore --configfile NuGet.Config
RUN dotnet publish -c Release -o out

# Build runtime image
FROM microsoft/dotnet:2.1-aspnetcore-runtime
WORKDIR /app2
COPY --from=build-env /app2/out .

EXPOSE 5002/tcp
ENV ASPNETCORE_URLS http://*:5002
ENTRYPOINT ["dotnet", "webapi-aws2.dll"]