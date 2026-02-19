# Kura

Kura is an AI-powered social media assistant with multi-model LLM support and persistent semantic memory. This repository serves as the monorepo umbrella that ties together the frontend, backend, and supporting infrastructure configuration.

---

## Repositories

| Repo | Description |
|------|-------------|
| [kura-backend](https://github.com/12jihan/kura-backend) | Node.js / TypeScript REST API with multi-model LLM support and pgvector semantic memory |
| [kura-frontend](https://github.com/12jihan/kura-frontend) | Angular frontend client |

Both are included as git submodules and maintain their own independent histories.

---

## Tech Stack

- **Frontend** — Angular
- **Backend** — Node.js, TypeScript, Express
- **Database** — PostgreSQL with pgvector for semantic memory
- **Reverse Proxy** — nginx
- **Containerization** — Docker / Docker Compose

---

## Project Structure

```
kura/
├── kura-backend/        # Backend submodule
├── kura-frontend/       # Frontend submodule
├── db/                  # Database migrations and seed scripts
├── nginx/               # nginx reverse proxy configuration
├── docker-compose.yml        # Production compose file
├── docker-compose.dev.yml    # Development compose file with hot reload
├── docrun.sh            # Helper script for running Docker commands
└── .gitmodules          # Submodule references
```

---

## Getting Started

### Prerequisites

- [Docker](https://www.docker.com/) and Docker Compose
- [Node.js](https://nodejs.org/) (for local development outside Docker)
- Git

### Clone with Submodules

```bash
git clone --recurse-submodules https://github.com/12jihan/kura.git
cd kura
```

If you already cloned without the flag:

```bash
git submodule update --init --recursive
```

### Running in Development

```bash
docker compose -f docker-compose.dev.yml up --build
```

This spins up the backend, frontend, PostgreSQL, and nginx with hot reloading enabled.

### Running in Production

```bash
docker compose up --build
```

---

## Submodule Workflow

Since the frontend and backend are independent repos linked as submodules, here are a few common operations:

**Switch all repos to a branch:**
```bash
git checkout dev
git submodule foreach "git checkout dev"
```

**Update submodule pointers after changes are pushed to the sub-repos:**
```bash
git submodule update --remote
git add kura-backend kura-frontend
git commit -m "chore: update submodule references"
git push
```

**Working inside a submodule:**
```bash
cd kura-backend   # or kura-frontend
# make changes, commit, push as normal
```

---

## Contributing

1. Fork the relevant submodule repo (`kura-backend` or `kura-frontend`)
2. Create a feature branch (`git checkout -b feat/your-feature`)
3. Commit your changes
4. Open a pull request against the `dev` branch

---

## License

MIT
