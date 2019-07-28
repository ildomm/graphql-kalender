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

Opening the application:

```
open http://localhost:3000/
```

## Sample GraphQL Queries

List first 10 links, containing "example":

```graphql
{
  allLinks(first: 10, filter: {descriptionContains: "example"}) {
    id
    url
    description
    createdAt
    postedBy {
      id
      name
    }
  }
}

{
  allEvents(first: 10 ) {
    id
    url
    createdAt
    postedBy {
      id
      name
    }
  }
}