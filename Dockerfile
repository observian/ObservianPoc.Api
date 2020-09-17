FROM mcr.microsoft.com/dotnet/core/sdk:3.1 as build
ARG NUGET_USERNAME
ARG NUGET_API_KEY

WORKDIR /build

COPY ./nuget.config ./

COPY ./ObservianPoc.Api/ObservianPoc.Api.csproj ./ObservianPoc.Api/ObservianPoc.Api.csproj
COPY ObservianPoc.Api.sln .

RUN echo $NUGET_USERNAME
RUN sed -i -e "s/ACTOR/$NUGET_USERNAME/g" -e "s/APIKEY/$NUGET_API_KEY/g" nuget.config

RUN dotnet restore ObservianPoc.Api.sln

COPY . .

RUN dotnet publish ObservianPoc.Api.sln -c Release -o /publish

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 as runtime 
WORKDIR /api 

COPY --from=build /publish .

CMD ["dotnet", "ObservianPoc.Api.dll"]

#NOTE: Build Image Command 
# docker build -t observianpoc-api —build-arg GITHUB_ACTOR=[GITUB_USER] —build-arg GITHUB_TOKEN=[GITHUB_TOKEN] .