# ���������� ����� ASP.NET Core SDK ��� ������ �������
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# ��������� ������� ����������
WORKDIR /app

# �������� ����� ������� � ��������������� �����������
COPY . ./
RUN dotnet restore "api.yawaflua.ru.csproj"

# �������� ������
RUN dotnet publish -c Release -o /app/out "api.yawaflua.ru.csproj"


# �������� �����, ������������ ASP.NET Core runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./
# ���������� ����, ������� ���������� ����� �������
EXPOSE 80
# ��������� ���������� �����
ENV CLIENTID=123
ENV CLIENTSECRET=aAbB
ENV REDIRECTURL=http://example.org/
ENV PSQL_HOST=localhost
ENV PSQL_USER=root
ENV PSQL_PASSWORD=root
ENV PSQL_DATABASE=database
ENV OWNERID=1111111
ENV READMEFILE=https://raw.githubusercontent.com/yawaflua/yawaflua/main/README.md

# ��������� ASP.NET Core ����������
ENTRYPOINT ["dotnet", "api.yawaflua.ru.dll"]
