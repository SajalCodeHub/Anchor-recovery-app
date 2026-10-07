<div align="center">

# ANCHOR

### A Free, Privacy-First Habit & Addiction Recovery Companion

**SE641 / CSCI695 — Application and Database Systems**  
**St. Cloud State University • Fall 2026**

<br>

![Academic Project](https://img.shields.io/badge/Academic%20Project-Fall%202026-4F46E5)
![Privacy First](https://img.shields.io/badge/Privacy-First-16A34A)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-336791?logo=postgresql&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-Caching-DC382D?logo=redis&logoColor=white)
![Status](https://img.shields.io/badge/Status-In%20Development-F59E0B)

</div>

---

## 📖 About the Project

ANCHOR is a database-backed habit and addiction recovery application designed to provide users with **free, private, and accessible tools** for recovery tracking, reflection, and peer encouragement.

Many existing recovery applications provide useful accountability tools such as sobriety streak tracking, trigger logging, and daily reminders. However, important features are often placed behind recurring subscription fees.

ANCHOR is designed as a **free, open, and privacy-first alternative**, with a strong focus on protecting sensitive user information through database-level controls and secure system design.

Sensitive information may include:

- Recovery history
- Relapse dates
- Emotional triggers
- High-risk situations
- Personal journal entries
- Recovery activity and trends

---

## 🎯 Project Goals

ANCHOR aims to:

- Provide real-time habit and recovery tracking
- Support daily check-ins and sobriety streak monitoring
- Provide immediate support during high-risk moments
- Allow users to privately record and search triggers and experiences
- Support anonymous peer encouragement
- Protect sensitive information through database-level security
- Demonstrate advanced database design beyond basic CRUD operations

---

## ✨ Core Features

| Feature | Description |
|---|---|
| **Streak & Log Dashboard** | Tracks daily check-ins, sobriety streaks, relapse events, urge trends, and recovery progress |
| **Emergency Panic Button** | Provides motivational messages, grounding prompts, and personal reminders during high-risk moments |
| **Trigger Journaling & Search** | Allows users to privately record triggers, stress levels, locations, notes, and recovery experiences |
| **Anonymous Support Feed** | Provides a pseudonymous community where users can give and receive encouragement without exposing sensitive recovery information |

---

## 🛠️ Technology Stack

### Database & Backend

- PostgreSQL
- Supabase
- Redis / Upstash Redis

### Advanced Database Features

- Row-Level Security (RLS)
- JSONB
- PostgreSQL Full-Text Search
- Materialized Views
- Time-Series Partitioning
- Query Optimization and Indexing

### APIs & Authentication

- Supabase Authentication
- REST APIs
- GraphQL APIs

Additional frontend and backend technologies may be added as development progresses.

---

## 🗄️ Database Design

ANCHOR uses PostgreSQL as its primary database platform, hosted through Supabase.

The project is designed to go beyond standard Create, Read, Update, and Delete operations by implementing more advanced database techniques.

### Basic Operations

CRUD operations support:

- User profiles
- Daily check-ins
- Journal entries
- Community posts

### Advanced Operations

| Database Technique | Purpose |
|---|---|
| **Time-Series Partitioning** | Keeps analytics queries efficient as check-in and urge data grows |
| **Redis Caching** | Provides fast access to active streak state and motivational content |
| **JSONB** | Supports flexible storage of journal-related information |
| **Full-Text Search** | Enables efficient keyword search across journal entries |
| **Row-Level Security** | Helps isolate sensitive records between users |
| **Materialized Views** | Precomputes streak and engagement statistics for faster dashboard analytics |
| **Query-Optimized Indexes** | Improves performance of frequently executed queries |

---

## 🧩 Project Development Areas

| Development Area | Main Responsibilities |
|---|---|
| **Authentication, Privacy & Security** | Authentication, RLS policies, session handling, field protection, and user data isolation |
| **Streak Engine & Core Daily Logs** | Daily check-ins, streak calculations, recovery history, materialized views, and related APIs |
| **Panic Button & Redis Caching** | Panic Button endpoint, motivational content, Redis caching, and event logging |
| **Journaling, Search & Anonymous Feed** | JSONB journal storage, full-text search, pseudonymous posting, and anonymous support |
| **Time-Series Analytics & Trend Engine** | Table partitioning, query optimization, analytics APIs, and recovery trend analysis |
| **Integration & Quality Assurance** | Cross-feature integration, testing, security verification, database validation, and deployment preparation |

---

## 🚦 Development Workflow

Development work is managed using:

- GitHub Issues
- GitHub Project Board
- Feature Branches
- Pull Requests
- Code Review
- Testing and QA

### Task Status Flow

```text
Not Started
    ↓
In Progress
    ↓
Ready for Integration
    ↓
Tested
    ↓
Done
```

### Status Definitions

| Status | Meaning |
|---|---|
| **Not Started** | The task has been identified but work has not started |
| **In Progress** | A team member is actively working on the task |
| **Ready for Integration** | Development is complete and ready to be reviewed or integrated |
| **Tested** | The integrated feature has been reviewed and tested |
| **Done** | The task has been fully completed and accepted |

> Live task progress will be maintained through the **ANCHOR GitHub Project Board**.

---

## Development Process

```text
Create GitHub Issue
        ↓
Assign Team Member
        ↓
Move to In Progress
        ↓
Create Feature Branch
        ↓
Develop Feature
        ↓
Commit Changes
        ↓
Push Feature Branch
        ↓
Open Pull Request
        ↓
Ready for Integration
        ↓
Review and Integrate
        ↓
Test Feature
        ↓
Move to Tested
        ↓
Merge into Main
        ↓
Done
```

---

## 🌿 Branching Strategy

The `main` branch represents the stable integrated version of the project.

Development work should be completed using feature branches.

Example:

```text
main
│
├── feature/authentication
├── feature/rls-security
├── feature/streak-engine
├── feature/panic-button
├── feature/journal-search
├── feature/anonymous-feed
└── feature/analytics
```

Major development work should not be performed directly on `main`.

Completed features should be integrated through Pull Requests.

---

## 🤝 Collaboration Guidelines

Team members should:

- Work from assigned GitHub Issues
- Keep task status updated on the Project Board
- Use feature branches for development
- Use clear and meaningful commit messages
- Push work regularly
- Open Pull Requests when work is ready
- Review changes before integration
- Test integrated features
- Document important technical decisions
- Communicate blockers and dependencies with the team
- Avoid overwriting another member's work

---

## 🗓️ Development Timeline

| Sprint | Weeks | Focus |
|---|:---:|---|
| **Sprint 0** | 1–2 | Baseline schema, environment setup, wireframes, and minimal authentication |
| **Sprint 1** | 3–6 | Parallel development of the four primary feature areas |
| **Sprint 2** | 7–8 | Time-Series Analytics & Trend Engine |
| **Sprint 3** | 9–10 | Feature Hardening & Cross-Feature Polish |
| **Sprint 4** | 11–12 | Integration |
| **Sprint 5** | 13–14 | Final Testing, Deployment, and Documentation |

Testing and quality assurance are intended to run continuously throughout development.

---

## 📁 Planned Repository Structure

```text
Anchor-recovery-app/
│
├── README.md
├── .gitignore
│
├── docs/
│   ├── architecture/
│   ├── database-design/
│   └── project-documentation/
│
├── database/
│   ├── schema/
│   ├── migrations/
│   ├── rls/
│   ├── views/
│   └── seed/
│
├── backend/
│
├── frontend/
│
├── tests/
│
└── scripts/
```

The repository structure may evolve as implementation decisions are finalized.

---

## 👥 Team Members

| Team Member |
|---|
| Sahar Atie |
| Anastasiya Gorlov |
| Kehinde O. Ayeyemi |
| Sajal Bhattarai |
| Assan Saidy |

---

## 📚 Course Information

| | |
|---|---|
| **Course** | SE641 / CSCI695 — Application and Database Systems |
| **Institution** | St. Cloud State University |
| **Semester** | Fall 2026 |
| **Project** | ANCHOR |

---

## 🚧 Current Status

**Current Status:** Initial Development / Project Setup

The team is currently working on:

- GitHub repository setup
- Team collaboration access
- GitHub Project Board
- Development workflow
- Database structure
- Development environment

---

## Academic Purpose

ANCHOR is being developed as an academic project for **SE641 / CSCI695 — Application and Database Systems**.

The project demonstrates practical experience with:

- Relational database design
- Advanced PostgreSQL functionality
- Database security
- Caching
- Search
- Analytics
- Application integration
- Collaborative software development

---

## ⚠️ Disclaimer

ANCHOR is an academic software project intended to support habit and addiction recovery tracking and reflection.

It is **not intended to replace professional medical, psychological, addiction-treatment, crisis, or emergency services**.

---

<div align="center">

### ANCHOR

**Private by Design • Accessible by Purpose • Built for Recovery**

St. Cloud State University • Fall 2026

</div>