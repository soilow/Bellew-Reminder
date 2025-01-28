FROM dart:stable AS build

workdir /app
COPY pubspec.* ./
RUN dart pub get

COPY . .
RUN dart pub get --offline

RUN dart compile exe bin/main.dart -o bin/server

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/bin/server /app/bin/

EXPOSE 8080
CMD ["/app/bin/server"]