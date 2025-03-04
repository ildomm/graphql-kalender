# 📅 GraphQL Kalender

<div align="center">

[![Ruby](https://img.shields.io/badge/Ruby-2.7%2B-red.svg)](https://www.ruby-lang.org/)
[![Rails](https://img.shields.io/badge/Rails-5.2.0-red.svg)](https://rubyonrails.org/)
[![GraphQL](https://img.shields.io/badge/GraphQL-1.13.23-pink.svg)](https://graphql.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Latest-blue.svg)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](LICENSE)

A modern calendar application built with GraphQL, aggregating events from multiple sources with powerful search capabilities.

[Getting Started](#getting-started) •
[Features](#features) •
[Development](#development) •
[GraphQL API](#graphql-api)

</div>

## ✨ Features

- 🔍 Advanced event search and filtering
- 📊 GraphQL-powered API
- 🔄 Automatic event imports
- 📱 Responsive design
- 🔒 Secure data handling

## 🚀 Getting Started

### Prerequisites

- Ruby 2.7+
- PostgreSQL
- Make

### Quick Setup

```bash
# Install and setup everything
make setup

# Start the server
make server

# Open in browser
make open
```

## 💻 Development

```bash
# Show all available commands
make help

# Common tasks
make test    # Run test suite
make lint    # Check code style
make clean   # Clean temporary files and logs
```

### Event Import

```bash
# Setup automatic imports
make cron

# Manual import
make import
```

## 📈 GraphQL API

### Event Queries

```graphql
# Get latest events
{
  allEvents(
    first: 10,
    orderBy: "createdAt_DESC"
  ) {
    id
    title
    startAt
    url
  }
}

# Search with filters
{
  allEvents(
    first: 10,
    filter: {
      titleContains: "Conference",
      startAtAfter: "2025-01-01"
    }
  ) {
    id
    title
    startAt
    url
  }
}

# Complex search
{
  allEvents(
    first: 10,
    filter: {
      titleContains: "Tech",
      OR: {
        urlContains: "conference"
      }
    }
  ) {
    id
    title
    startAt
    url
  }
}
```

## 🛠 Available Commands

| Command | Description |
|---------|-------------|
| `make setup` | Complete project setup |
| `make server` | Start development server |
| `make test` | Run test suite |
| `make lint` | Check code style |
| `make clean` | Clean temporary files and logs |
| `make cron` | Setup automatic event imports |
| `make import` | Manual event import |

## 📚 Documentation

- [GraphQL Schema](docs/schema.md)
- [API Documentation](docs/api.md)
- [Development Guide](docs/development.md)

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.