FROM mcr.microsoft.com/dotnet/core/sdk:3.1 as build
ARG GITHUB_ACTOR
ARG GITHUB_TOKEN

WORKDIR /build

COPY ./nuget.config ./

COPY ./ObservianPoc.Api/ObservianPoc.Api.csproj ./ObservianPoc.Api/ObservianPoc.Api.csproj
COPY ObservianPoc.Api.sln .

RUN sed -i -e "s/ACTOR/$GITHUB_ACTOR/g" -e "s/APIKEY/$GITHUB_TOKEN/g" nuget.config

RUN dotnet restore ObservianPoc.Api.sln

COPY . .

RUN dotnet publish ObservianPoc.Api.sln -c Release -o /publish

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 as runtime 
WORKDIR /api 

COPY --from=build /publish .

CMD ["dotnet", "ObservianPoc.Api.dll"]

#NOTE: Build Image Command 
# docker build -t observianpoc-api —build-arg GITHUB_ACTOR=[GITUB_USER] —build-arg GITHUB_TOKEN=[GITHUB_TOKEN] .