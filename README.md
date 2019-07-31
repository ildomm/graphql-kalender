# graphql-kalendar
     
## Installation

Database configuration:
```
CREATE USER kalendar;
ALTER USER kalendar WITH ENCRYPTED PASSWORD 'rdenadark';
CREATE DATABASE "kalendar_development";
GRANT ALL PRIVILEGES ON DATABASE kalendar_development TO kalendar;
CREATE DATABASE "kalendar_test";
GRANT ALL PRIVILEGES ON DATABASE kalendar_test TO kalendar;
CREATE DATABASE "kalendar_production";
GRANT ALL PRIVILEGES ON DATABASE kalendar_production TO kalendar;
```

Install dependencies:

```
bundle install

rails db:migrate
rails db:seed
```

Starting the server:
```
rails server
```

Importing events using Cron:
```
whenever --update-crontab
```

Importing events manually:
```
rake explore:go
```

Opening the application:
```
open http://localhost:3000/
```

## Sample GraphQL Queries

List first 10 events:

```graphql
{ allEvents(first: 10 ) {
    id
    url
    createdAt
    postedBy {
      name
    }
  }
}

{ allEvents(first: 10, filter: { titleContains: "The"}) {
  id,
  url,
  title,
  startAt
  } 
}

{ allEvents(first: 10, filter: { startAtAfter: "2019-08-05"}) {
  id,
  url,
  title,
  startAt
  } 
}

{ allEvents(first: 10, 
            filter: { titleContains: "The" , 
                OR: { urlContains: "29" },  } ) {
  id,
  url,
  title,
  startAt
  } 
}