FROM microsoft/dotnet:2.1-sdk AS build-env

# Copy everything else and build
COPY . /app1
WORKDIR /app1

# RUN dotnet restore --configfile NuGet.Config
RUN dotnet publish -c Release -o out

# Build runtime image
FROM microsoft/dotnet:2.1-aspnetcore-runtime
WORKDIR /app1
COPY --from=build-env /app1/out .

EXPOSE 5001/tcp
# ENV ASPNETCORE_URLS https://*:5001
# turn off https
ENV ASPNETCORE_URLS http://*:5001
ENTRYPOINT ["dotnet", "webapi-aws1.dll"]